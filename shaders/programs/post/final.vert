// Attributes

in vec2 vaUV0;
in vec3 vaPosition;

// Outputs
out vec2 texCoord;

// Uniforms

uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
}