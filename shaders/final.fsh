#version 450 core

// ----- Uniforms -----

uniform sampler2D colortex0;

// ----- Input -----

in vec2 texCoord;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;

void main(){
    color = texture(colortex0, texCoord);
    color = pow(color, vec4(1.0/2.2));
}