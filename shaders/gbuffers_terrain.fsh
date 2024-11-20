#version 450 core

// ----- Input -----
in vec2 texCoord;
in vec4 terrainColor;

// ----- Uniforms -----
uniform sampler2D colortex0;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

void main(){
    vec4 color = texture(colortex0, texCoord) * terrainColor;
    if(color.a < 0.1) discard;
    fragColor = color;
}