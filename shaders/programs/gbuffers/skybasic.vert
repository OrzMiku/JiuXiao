#include "/libs/settings.glsl"

// Attributes

in vec3 vaPosition;
in vec4 vaColor;

// Outputs

out vec4 glColor;

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
    if(TAA == ON){
        gl_Position.xy = taaJitter(gl_Position.xy, gl_Position.w);
    }

    glColor = vaColor;
}