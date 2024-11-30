#version 450 core

// ----- Includes -----
#include "/lib/function/util.glsl"
#include "/lib/function/distort.glsl"

// ----- Uniforms -----

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float far;

uniform vec3 fogColor; 
uniform vec3 skyColor;
uniform vec3 upPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 modelViewMatrixInverse;

// ----- Input -----

in vec2 texCoord;

// ----- Output -----

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// ----- Functions -----
vec3 calcSkyColor(vec3 viewPos){
    float upDot = dot(normalize(viewPos), upPosition);
    vec3 mySkyColor = RGB2HSV(skyColor);
    mySkyColor.x = mySkyColor.x ;
    mySkyColor.y = 1.0;
    mySkyColor = HSV2RGB(mySkyColor);

    if(upDot > 0.0){
        return mix(fogColor, mySkyColor, smoothstep(0.0, length(upPosition) * 0.8, upDot));
    }else{
        return fogColor;
    }
}

void main(){
    color = texture(colortex0, texCoord);
    float depth = texture(depthtex0, texCoord).r;

    vec3 NDCPos = vec3(texCoord, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);

    float fogFactor = expDecay(5.0, length(viewPos)/far);
    fogFactor = clamp(fogFactor, 0.0, 1.0);

    color.rgb = mix(color.rgb, fogColor, fogFactor);

    if(depth == 1.0){
        color.rgb = calcSkyColor(viewPos);
    }
}