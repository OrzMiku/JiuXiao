// Uniforms
#include "/libs/uniforms.glsl"

// Inputs
in vec2 texCoord;
in vec2 lmCoord;
in vec3 normal;
in vec4 tint;

// Outputs
/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 encodedNormal;
layout(location = 2) out vec4 lightmapData;

// Main
void main(){
    color = texture(colortex0, texCoord) * tint;

    // Write normal and lmCoord
    encodedNormal = vec4(normalize(normal) * 0.5 + 0.5, 1.0);
    lightmapData = vec4(lmCoord, 0.0, 1.0);

    // Alpha test
    if(color.a < alphaTestRef){
        discard;
    }

    // Gamma correction
    color.rgb = pow(color.rgb, vec3(2.2));
}