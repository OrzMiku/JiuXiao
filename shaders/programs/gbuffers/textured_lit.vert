
// ----- Uniform -----

uniform int frameCounter;

uniform float viewHeight;
uniform float viewWidth;

uniform mat4 gbufferModelViewInverse;

// ----- Include ------

#include "/lib/jitter.glsl"

// ----- Output -----

out float dist;

out vec2 texCoord;
out vec2 lightmapCoord;
out vec3 normal;
out vec4 glColor;

// ----- Main -----

void main(){
    vec3 modelPos = gl_Vertex.xyz;
    vec4 viewPos = gl_ModelViewMatrix * vec4(modelPos, 1.0);
    vec4 clipPos = gl_ProjectionMatrix * viewPos;

    gl_Position = clipPos;

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lightmapCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    lightmapCoord = (lightmapCoord * 33.05 / 32.0) - (1.05 / 32.0);

    normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = mat3(gbufferModelViewInverse) * normal;

    glColor = gl_Color;

    gl_Position.xy = TAAJitter(gl_Position.xy, gl_Position.w);
}