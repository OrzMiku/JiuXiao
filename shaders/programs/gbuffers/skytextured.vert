// ----- Uniform -----

uniform int frameCounter;

uniform float viewHeight;
uniform float viewWidth;

uniform mat4 gbufferModelViewInverse;

// ----- Include ------

#include "/lib/jitter.glsl"

// ----- Output -----

out vec2 texCoord;
out vec4 glColor;

// ----- Main -----

void main(){
    vec3 modelPos = gl_Vertex.xyz;
    vec4 viewPos = gl_ModelViewMatrix * vec4(modelPos, 1.0);
    vec4 clipPos = gl_ProjectionMatrix * viewPos;

    gl_Position = clipPos;
    gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    glColor = gl_Color;
}