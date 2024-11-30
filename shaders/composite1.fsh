#version 450 core

// ----- Includes -----
#include "/lib/function/util.glsl"
#include "/lib/function/distort.glsl"

// ----- Uniforms -----

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float far;

uniform vec3 fogColor; 

uniform mat4 gbufferProjectionInverse;

// ----- Input -----

in vec2 texCoord;

// ----- Output -----

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main(){
    color = texture(colortex0, texCoord);
    float depth = texture(depthtex0, texCoord).r;

    if(depth == 1.0) return;

    vec3 NDCPos = vec3(texCoord, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);

    float fogFactor = expDecay(5.0, length(viewPos)/far);
    fogFactor = clamp(fogFactor, 0.0, 1.0);
    
    color.rgb = mix(color.rgb, fogColor, fogFactor);
}