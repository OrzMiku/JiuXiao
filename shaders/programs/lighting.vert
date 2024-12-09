// Attributes

in vec2 vaUV0;
in vec3 vaPosition;

// Outputs

out vec2 texCoord;

// Uniforms

uniform int frameCounter;
uniform float viewWidth;
uniform float viewHeight;

uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// TAA

#include "/libs/jitter.glsl"

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
    texCoord = (vec4(vaUV0, 0.0, 1.0)).xy;
}