#version 450 core

// ----- Uniforms -----

uniform sampler2D colortex0;

// ----- Input -----

in vec2 texCoord;
in vec4 glColor;

// ----- Output -----

layout(location = 0) out vec4 color;

void main(){
    color = texture(colortex0, texCoord) * glColor;
    if(color.a < 0.1) discard;
}