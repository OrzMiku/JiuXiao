
// ----- Constants ------

const bool colortex1Clear = false;

const vec2 neighbourhoodOffsets[8] = vec2[8](
    vec2(-1.0, -1.0),
    vec2( 0.0, -1.0),
    vec2( 1.0, -1.0),
    vec2(-1.0,  0.0),
    vec2( 1.0,  0.0),
    vec2(-1.0,  1.0),
    vec2( 0.0,  1.0),
    vec2( 1.0,  1.0)
);

// ----- Layout -----

/* DRAWBUFFERS:01 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 prevColor;

// ----- Uniform -----

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferModelViewInverse;

// ----- Input -----

in vec2 texCoord;

// ----- Include -----

#include "/lib/function.glsl"

// ----- Function -----

vec2 Reprojection(vec2 screenPos, float depth){
    // Transform to NDC space
    screenPos = screenPos * 2.0 - 1.0;
    depth = depth * 2.0 - 1.0;

    // Transform to world space
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, vec3(screenPos, depth));
    vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;

    // Calculate camera offset
    vec3 cameraOffset = depth > 0.56 ? cameraPosition - previousCameraPosition : vec3(0.0);

    // Reproject previous position
    vec4 prevPos = gbufferPreviousProjection * gbufferPreviousModelView * vec4(worldPos + cameraOffset, 1.0);

    // Normalize to [0, 1]
    return (prevPos.xy / prevPos.w) * 0.5 + 0.5;
}

vec3 colorClamp(vec3 color, vec3 tempColor, vec2 viewInv){
	vec3 minColor = color;
	vec3 maxColor = color;

	for (int i = 0; i < 8; i++){
		color = texture(colortex0, texCoord + neighbourhoodOffsets[i] * viewInv).rgb;
		minColor = min(minColor, color);
		maxColor = max(maxColor, color);
	}
	
	return clamp(tempColor, minColor, maxColor);
}

vec3 TAA(vec3 color){
	vec2 prevCoord = Reprojection(texCoord, texture(depthtex0, texCoord).r);

	vec3 tempColor = texture(colortex1, prevCoord).rgb;
	if (tempColor == vec3(0.0)) return color;

	// Clamp temporary color based on neighborhood
	vec2 viewInv = vec2(1.0 / viewWidth, 1.0 / viewHeight);
	tempColor = colorClamp(color, tempColor, viewInv);

	// Calculate velocity and blend factor
	vec2 velocity = (texCoord - prevCoord) * vec2(viewWidth, viewHeight);
	float blendFactor = exp(-length(velocity)) * 0.6 + 0.3;

	// Apply blend factor
	color = mix(color, tempColor, blendFactor);
	return color;
}

// ----- Main -----

void main()
{
    color.rgb = TAA(texture(colortex0, texCoord).rgb);
    prevColor = color;
}