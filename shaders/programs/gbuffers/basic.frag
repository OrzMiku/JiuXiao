// Inputs

in vec2 lmCoord;
in vec4 glColor;

// Uniforms

#include "/libs/uniforms.glsl"

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main(){
    color = glColor * texture(lightmap, lmCoord);

    if(color.a < alphaTestRef){
        discard;
    }
}