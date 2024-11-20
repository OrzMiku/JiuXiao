#version 450 core

// ----- Input -----
in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;

// ----- Output -----
out vec2 texCoord;
out vec4 terrainColor;

// ----- Uniforms -----
uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main(){
    vec4 clipPos = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    gl_Position = clipPos;
    texCoord = vaUV0;
    terrainColor = vaColor;
}