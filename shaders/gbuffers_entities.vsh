#version 450 core

// ----- Uniforms -----

uniform vec3 chunkOffset;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;
uniform mat4 textureMatrix;

// ----- Input -----

in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec3 vaNormal;
in vec4 vaColor;

// ----- Output -----

out vec2 texCoord;
out vec2 lightmapCoord;
out vec3 normal;
out vec4 glColor;

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    
    glColor = vaColor;
    
    normal = normalMatrix * vaNormal;
    normal = mat3(gbufferModelViewInverse) * normal;
    
    lightmapCoord = vaUV2;
    lightmapCoord *= 0.00416666;
}