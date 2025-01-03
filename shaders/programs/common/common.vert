// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Outputs
out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 tint;

// Main
void main(){
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    
    texCoord = gl_MultiTexCoord0.xy;
}