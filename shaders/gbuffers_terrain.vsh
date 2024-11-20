#version 450 core

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
out vec4 terrainColor;

// ----- Uniforms -----
uniform vec3 chunkOffset;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;

void main(){
    vec4 clipPos = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    gl_Position = clipPos;

    texCoord = vaUV0;
    
    terrainColor = vaColor;
    
    normal = normalMatrix * vaNormal;
    normal = mat3(gbufferModelViewInverse) * normal;
    
    lightmapCoord = vaUV2;
    lightmapCoord *= 0.00416666;
}