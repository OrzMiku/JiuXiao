#include "/libs/settings.glsl"

// Attributes

in float mc_Entity;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec3 vaNormal;
in vec4 vaColor;

// Outputs

out float lightIntensity;
out vec2 texCoord;
out vec2 lmCoord;
out vec4 glColor;

// Uniforms

uniform int frameCounter;
uniform float viewWidth;
uniform float viewHeight;

uniform vec3 chunkOffset;
uniform mat3 normalMatrix;
uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;

// TAA

#include "/libs/jitter.glsl"

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    if(TAA == ON){
        gl_Position.xy = taaJitter(gl_Position.xy, gl_Position.w);
    }

    const mat4 TEXTURE_MATRIX_2 = mat4(vec4(0.00390625, 0.0, 0.0, 0.0), vec4(0.0, 0.00390625, 0.0, 0.0), vec4(0.0, 0.0, 0.00390625, 0.0), vec4(0.03125, 0.03125, 0.03125, 1.0));
    lmCoord = (TEXTURE_MATRIX_2 * vec4(vaUV2, 0.0, 1.0)).xy;

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    glColor = vaColor;

    vec3 normal = normalMatrix * vaNormal;
    normal = normalize(normal);
    normal = (round(mc_Entity) == 10001) ? vec3(0.0, 1.0, 0.0) : (gbufferModelViewInverse * vec4(normal, 0.0)).xyz;

    lightIntensity = min(normal.x * normal.x * 0.6 + normal.y * normal.y * 0.25 * (3.0 + normal.y) + normal.z * normal.z * 0.8, 1.0);
}