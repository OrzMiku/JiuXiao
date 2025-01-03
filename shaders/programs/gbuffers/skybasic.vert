// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Outputs
out vec4 tint;

// Functions
#include "/libs/functions.glsl"

// Main
void main(){
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    if(TAA) gl_Position.xy += taaOffset * gl_Position.w;
    
    tint = gl_Color;
}