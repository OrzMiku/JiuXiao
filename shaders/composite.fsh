#version 450 core

// ----- Parameters -----

#define SHADOW_QUALITY 2.0
#define SHADOW_SOFTNESS 1.0

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
uniform sampler2D noisetex;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform float viewWidth;
uniform float viewHeight;

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

vec4 getNoise(vec2 uv){
    ivec2 screenPos = ivec2(uv * vec2(viewWidth, viewHeight));
    ivec2 noisePos = screenPos % 64;
    return texelFetch(noisetex, noisePos, 0);
}

vec3 getShadow(vec3 shadowScreenPos){
    float transparentShadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);
    if(transparentShadow == 1.0) return vec3(1.0);

    float opaqueShadow = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r);
    if(opaqueShadow == 0.0) return vec3(0.0);

    vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);
    return shadowColor.rgb - shadowColor.a;
}

vec3 getSoftShadow(vec4 shadowClipPos){
    const float range = SHADOW_SOFTNESS / 2.0;
    const float increment = range / SHADOW_QUALITY;
    vec3 shadowAccum = vec3(0.0);
    int samples = 0;

    float noise = getNoise(texCoord).r;

    float theta = noise * radians(360.0);
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);

    for(float x = -range; x <= range; x += increment){
        for (float y = -range; y <= range; y+= increment){
        vec2 offset = rotation * vec2(x, y) / shadowMapResolution;
        vec4 offsetShadowClipPos = shadowClipPos + vec4(offset, 0.0, 0.0);
        offsetShadowClipPos.z -= 0.001;
        offsetShadowClipPos.xyz = distortShadowClipPos(offsetShadowClipPos.xyz);
        vec3 shadowNDCPos = offsetShadowClipPos.xyz / offsetShadowClipPos.w;
        vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;
        shadowAccum += getShadow(shadowScreenPos);
        samples++;
        }
    }

    return shadowAccum / float(samples);
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

    vec3 shadow = getSoftShadow(shadowClipPos);

    vec3 blocklight = texture(colortex1, texCoord).r * blocklightColor;
    vec3 skylight = texture(colortex1, texCoord).g * skylightColor;
    vec3 ambient = ambientColor;
    vec3 lightVector = normalize(shadowLightPosition);
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;
    float lightDot = max(dot(normal, worldLightVector), 0.0);
    vec3 sunlight = sunlightColor * lightDot * shadow;
    
    color.rgb *= blocklight + skylight + ambient + sunlight;
}