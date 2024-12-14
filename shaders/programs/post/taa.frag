#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Constants
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

// Inputs
in vec2 texCoord;

// Outputs
/* RENDERTARGETS: 0,1 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 prevColor;

// Functions
#include "/libs/functions.glsl"

vec2 Reprojection(vec2 coord, float depth){
    vec3 ndcPos = vec3(coord, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos);
    vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
    vec3 cameraOffset = cameraMovement;
    vec4 prevPos = gbufferPreviousProjection * gbufferPreviousModelView * vec4(feetPlayerPos + cameraOffset, 1.0);
    prevPos /= prevPos.w;
    return prevPos.xy * 0.5 + 0.5;
}

vec3 colorClamp(vec3 color, vec3 tempColor, vec2 viewInv){
    vec3 minColor = color;
    vec3 maxColor = color;

    for (int i = 0; i < 8; i++){
        vec3 sampledColor = texture(colortex0, texCoord + neighbourhoodOffsets[i] * viewInv).rgb;
        minColor = min(minColor, sampledColor);
        maxColor = max(maxColor, sampledColor);
    }
    
    return clamp(tempColor, minColor, maxColor);
}

vec3 TemporalAA(vec3 color){
    vec2 prevCoord = Reprojection(texCoord, texture(depthtex0, texCoord).r);
    vec3 prevColor = texture(colortex1, prevCoord).rgb;
    if(prevColor == vec3(0.0)) return color;

	prevColor = colorClamp(color, prevColor, texelSize);

    vec2 velocity = (texCoord - prevCoord) * screenSize;
    float blendFactor = exp(-length(velocity)) * 0.6 + 0.3;

    color = mix(color, prevColor, blendFactor);
    return color;
}

// Main
void main(){
    color = texture(colortex0, texCoord);
    if(TAA){
        color.rgb = TemporalAA(color.rgb);
    };
    prevColor = color;

    if(color.a < alphaTestRef){
        discard;
    }
}