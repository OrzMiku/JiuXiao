#version 450 core

// ----- Input -----
in vec2 texCoord;
in vec2 lightmapCoord;
in vec3 normal;
in vec4 terrainColor;

// ----- Uniforms -----
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 lightmapData;
layout(location = 2) out vec4 encodedNormal;

void main(){
    vec4 color = texture(colortex0, texCoord) * terrainColor;
    if(color.a < 0.1) discard;
    fragColor = color;

    lightmapData = vec4(lightmapCoord, 0.0, 1.0);
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}