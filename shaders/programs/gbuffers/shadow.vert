#include "/libs/settings.glsl"

// Outputs

out vec4 glColor;
out vec2 texCoord;

// Functions

#include "/libs/distort.glsl"

// Main

void main(){
    gl_Position = ftransform();
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    glColor = gl_Color;
}