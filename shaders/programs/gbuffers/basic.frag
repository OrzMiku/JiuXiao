// Inputs

in vec2 lmCoord;
in vec4 glColor;

// Uniforms

uniform sampler2D lightmap;

uniform float alphaTestRef;

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main(){
    color = glColor * texture(lightmap, lmCoord);

    if(color.a < alphaTestRef){
        discard;
    }
}