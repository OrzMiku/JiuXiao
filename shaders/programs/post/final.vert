// Uniforms
#include "/libs/uniforms.glsl"

// Attributes
in vec2 vaUV0;
in vec3 vaPosition;

// Outputs
out vec2 texCoord;

// Main
void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
    texCoord = vaUV0;
}