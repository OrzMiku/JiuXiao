
// ----- Output -----

out vec2 texCoord;
out vec4 glColor;

// ----- Include ------

#include "/lib/distort.glsl"

// ----- Main -----

void main(){
    vec3 modelPos = gl_Vertex.xyz;
    vec4 viewPos = gl_ModelViewMatrix * vec4(modelPos, 1.0);
    vec4 clipPos = gl_ProjectionMatrix * viewPos;

    gl_Position = clipPos;
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    glColor = gl_Color;
}