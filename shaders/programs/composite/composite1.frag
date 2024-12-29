#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"


// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Inputs
in vec2 texCoord;

// Functions
#include "/libs/functions.glsl"

// Main
void main()
{
    color = texture(colortex0, texCoord);

    if(!FOG_TOGGLE) return;

    float depth = texture(depthtex0, texCoord).r;
    vec3 viewPos = screenToView(vec3(texCoord, depth));

    float dist = length(viewPos) / far;
    float fogFactor = exp(-FOG_DENSITY * (1.0 - dist));

    color.rgb = mix(color.rgb, fogColor * vec3(FOG_COLOR_R, FOG_COLOR_G, FOG_COLOR_B) * sunIntensity, clamp(fogFactor, 0.0, 1.0));
}