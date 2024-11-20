#version 450 core

// ----- Uniforms -----

uniform mat4 textureMatrix;

// ----- Input -----

in vec3 vaPosition;
in vec2 vaUV0;

// ----- Output -----

out vec2 texCoord;

void main(){
    gl_Position = vec4(vaPosition * 2.0 - 1.0, 1.0);
    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
}