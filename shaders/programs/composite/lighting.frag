#include "/libs/settings.glsl"

// Constants

const vec3 ambientColor = vec3(0.1);
const vec3 blocklightColor = vec3(1.0, 0.5, 0.08) * 0.4;
const vec3 skylightColor = vec3(0.10, 0.20, 0.3);
const vec3 sunlightColor = vec3(1.0, 0.9, 0.8);

// Inputs

in vec2 texCoord;

// Uniforms

#include "/libs/uniforms.glsl"

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions

#include "/libs/functions.glsl"
#include "/libs/shadow.glsl"
#include "/libs/lighting.glsl"

// ----- Main -----

void main()
{
    color = texture(colortex0, texCoord);
    if(WHITE_WORLD == ON){ color.rgb = vec3(1.0); }
    applyLighting();
}