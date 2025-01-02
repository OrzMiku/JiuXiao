#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Constants
const vec3 ambientColor = vec3(0.1);
const vec3 blocklightColor = vec3(1.0, 0.5, 0.08) * 0.4;
const vec3 skylightColor = vec3(0.10, 0.20, 0.3);
const vec3 sunlightColor = vec3(1.0, 0.9, 0.8);

// Inputs
in vec2 texCoord;

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions
#include "/libs/functions.glsl"
#include "/libs/shadow.glsl"
#include "/libs/lighting.glsl"

// Main
void main()
{
    color = texture(colortex0, texCoord);
    if(WHITE_WORLD){ color.rgb = vec3(1.0); }

    float depth = texture(depthtex0, texCoord).r;
    vec3 NDCPos = vec3(texCoord.xy, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
    vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;

    // Sky
    if(depth == 1.0){
        vec4 clipPos = gbufferProjection * vec4(viewPos, 1.0);
        clipPos.xy += taaOffset * clipPos.w;
        viewPos = (gbufferProjectionInverse * clipPos).xyz;
        color.rgb += drawSun(normalize(viewPos), normalize(shadowLightPosition));
        return;
    }

    // Lighting
    applyLighting(feetPlayerPos);
}