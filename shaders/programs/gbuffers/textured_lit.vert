#include "/libs/settings.glsl"

// Attributes

in float mc_Entity;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec3 vaNormal;
in vec4 vaColor;

// Outputs

out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 glColor;

// Uniforms

uniform int frameCounter;
uniform float viewWidth;
uniform float viewHeight;

uniform vec3 chunkOffset;
uniform mat3 normalMatrix;
uniform mat4 textureMatrix = mat4(1.0);
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

    normal = normalize(normalMatrix * vaNormal);
    normal = mat3(gbufferModelViewInverse) * normal;
}