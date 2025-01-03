// Uniforms
#include "/libs/uniforms.glsl"

// Inputs
in vec2 texCoord;
in vec4 tint;

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Main
void main(){
    color = texture(colortex0, texCoord) * tint;

    // Alpha test
    if(color.a < alphaTestRef){
        discard;
    }

    // Gamma correction
    color.rgb = pow(color.rgb, vec3(2.2));
}