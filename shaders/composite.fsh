#version 450 core

// ----- Includes -----
#include "lib/distort.glsl"

// ----- Uniforms -----

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

// ----- Input -----

in vec2 texCoord;

// ----- Output -----

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// ----- Constants -----

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0);
const vec3 ambientColor = vec3(0.1);

// ----- Functions -----

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
    vec4 clipSpace = projectionMatrix * vec4(position, 1.0);
    vec3 ndcSpace = clipSpace.xyz / clipSpace.w;
    return ndcSpace;
}

vec3 getShadow(vec3 shadowScreenPos){
    float transparentShadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);
    if(transparentShadow == 1.0) return vec3(1.0);

    float opaqueShadow = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r);
    if(opaqueShadow == 0.0) return vec3(0.0);

    vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);
    return shadowColor.rgb - shadowColor.a;
}

void main(){
    color = texture(colortex0, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    vec3 normal = texture(colortex2, texCoord).rgb * 2.0 - 1.0;

    if(depth == 1.0) return;

    vec3 NDCPos = vec3(texCoord, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
    vec3 modelPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
    vec3 shadowViewPos = (shadowModelView * vec4(modelPos, 1.0)).xyz;
    vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
    shadowClipPos.z -= 0.001;
    shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz);
    vec3 shadowNDCPos = shadowClipPos.xyz / shadowClipPos.w;
    vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;

    vec3 shadow = getShadow(shadowScreenPos);

    vec3 blocklight = texture(colortex1, texCoord).r * blocklightColor;
    vec3 skylight = texture(colortex2, texCoord).g * skylightColor;
    vec3 ambient = ambientColor;
    vec3 lightVector = normalize(shadowLightPosition);
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;
    float lightDot = max(dot(normal, worldLightVector), 0.0);
    vec3 sunlight = sunlightColor * lightDot * shadow;

    color.rgb *= blocklight + skylight + ambient + sunlight;
}