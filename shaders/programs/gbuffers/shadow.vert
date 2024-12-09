#include "/libs/settings.glsl"

// Attributes

in ivec2 vaUV2;
in vec3 vaPosition;
in vec4 vaColor;

// Outputs

out vec4 glColor;

// Uniforms

uniform int frameCounter;
uniform float viewWidth;
uniform float viewHeight;

uniform vec3 chunkOffset;
uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// Functions

#include "/libs/jitter.glsl"
#include "/libs/distort.glsl"

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);

    glColor = vaColor;
}