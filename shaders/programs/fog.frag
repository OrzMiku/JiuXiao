#include "/libs/settings.glsl"
#include "/libs/functions.glsl"

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Inputs

in vec2 texCoord;

uniform float viewWidth;
uniform float viewHeight;
uniform float far;

uniform vec3 customFogColor;

// Uniforms

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

// Functions

vec3 screenToView(vec3 screenPos) {
	vec3 ndcPos = screenPos * 2.0 - 1.0;
    return projectAndDivide(gbufferProjectionInverse, ndcPos);
}

// Main

void main()
{
    color = texture(colortex0, texCoord);

    if(FOG_TOGGLE == OFF) return;

    float depth = texture(depthtex0, texCoord).r;
    vec3 viewPos = screenToView(vec3(texCoord, depth));

    float dist = length(viewPos) / far;
    float fogFactor = exp(-FOG_DENSITY * (1.0 - dist));

    color.rgb = mix(color.rgb, customFogColor, clamp(fogFactor, 0.0, 1.0));
}