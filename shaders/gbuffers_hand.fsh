#version 450 core

// ----- Uniforms -----

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

// ----- Input -----

in vec2 texCoord;
in vec2 lightmapCoord;
in vec3 normal;
in vec4 glColor;

// ----- Output -----

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 lightmapData;
layout(location = 2) out vec4 encodedNormal;

void main(){
    color = texture(colortex0, texCoord) * glColor;
    if(color.a < 0.1) discard;
    color.rgb = pow(color.rgb, vec3(2.2));

    lightmapData = vec4(lightmapCoord, 0.0, 1.0);
    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}