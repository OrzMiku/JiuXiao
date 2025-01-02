#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Attributes
in vec2 vaUV0;
in vec3 vaPosition;
in vec4 vaColor;

// Outputs
out vec4 glColor;
out vec2 texCoord;

// Functions
#include "/libs/shadow.glsl"

// Main
void main(){
    gl_Position =  projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    glColor = vaColor;
}