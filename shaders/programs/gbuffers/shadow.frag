
// Inputs

in vec2 texCoord;
in vec4 glColor;

// Uniforms

uniform float alphaTestRef;

uniform sampler2D gtexture;

// Outputs

/* RENDERTARGETS: 0 */
layout (location = 0) out vec4 color;

// Main

void main(){
    color = texture(gtexture, texCoord) * glColor;

    if(color.a < alphaTestRef) discard;
}