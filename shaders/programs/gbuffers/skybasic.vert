#include "/libs/settings.glsl"

// Attributes

in vec3 vaPosition;
in vec4 vaColor;

// Outputs

out vec4 glColor;

// Uniforms

#include "/libs/uniforms.glsl"

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
    if(TAA == ON){
        gl_Position.xy += taaOffset * gl_Position.w;
    }

    glColor = vaColor;
}