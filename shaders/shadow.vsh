#version 450 core

// ----- Includes -----
#include "lib/distort.glsl"

// ----- Uniforms -----

uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 textureMatrix;

// ----- Input -----

in vec2 vaUV0;
in vec3 vaPosition;
in vec4 vaColor;

// ----- Output -----

out vec2 texCoord;
out vec4 glColor;

void main(){
    vec4 shadowClipPos = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz);
    gl_Position = shadowClipPos;

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    
    glColor = vaColor;
}