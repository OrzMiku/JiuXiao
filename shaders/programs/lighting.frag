
#include "/libs/settings.glsl"

// Constants

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 ambientColor = vec3(0.1);
const vec3 skylightColor = vec3(0.10, 0.20, 0.3);
const vec3 sunlightColor = vec3(1.0, 0.9, 0.8);

// Inputs

in vec2 texCoord;

// Uniforms

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform sampler2D noisetex;

uniform float sunIntensity;
uniform float viewHeight;
uniform float viewWidth;

uniform vec3 shadowLightPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

// Outputs

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

// Functions

#include "/libs/distort.glsl"
#include "/libs/functions.glsl"

vec4 getNoise(vec2 coord){
  ivec2 screenCoord = ivec2(coord * vec2(viewWidth, viewHeight));
  ivec2 noiseCoord = screenCoord % 64;
  return texelFetch(noisetex, noiseCoord, 0);
}

vec3 calcShadow(vec3 shadowScreenPos){
    // Transparent -> no shadow
    float transparentShadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r); // sample the shadow map containing everything
    if(transparentShadow == 1.0){
        return vec3(1.0);
    }

    // Opaque -> full shadow
    float opaqueShadow = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r); // sample the shadow map containing only opaque stuff
    if(opaqueShadow == 0.0){
        return vec3(0.0);
    }

    // Semi transparent
    vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);
    return shadowColor.rgb * shadowColor.a;
}

vec3 calcSoftShadow(vec4 shadowClipPos){
    const float range = SHADOW_SOFTNESS / 2.0;
    const float increment = range / SHADOW_QUALITY;

    float noise = getNoise(texCoord).r;
    float theta = noise * radians(360.0);
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);

    vec3 shadowAccum = vec3(0.0);
    int samples = 0;

    for(float x = -range; x <= range; x += increment){
        for (float y = -range; y <= range; y += increment){
            vec2 offset = rotation * vec2(x, y) / shadowMapResolution;
            vec4 offsetShadowClipPos = shadowClipPos + vec4(offset, 0.0, 0.0);
            offsetShadowClipPos.xyz = distortShadowClipPos(offsetShadowClipPos.xyz);
            offsetShadowClipPos.z -= 0.001;

            vec3 shadowNDCPos = offsetShadowClipPos.xyz / offsetShadowClipPos.w;
            vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;
            shadowAccum += calcShadow(shadowScreenPos);
            samples++;
        }
    }

    return shadowAccum / float(samples);
}

void applyLightingIntensity(inout vec3 color, float intensity){
    color *= intensity;
}

void applyShadow(inout vec3 color, vec3 shadow){
    color *= shadow;
}

vec3 calcLighting(){
    float depth = texture(depthtex0, texCoord).r;
    if(depth == 1.0) return vec3(1.0);
    vec3 NDCPos = vec3(texCoord.xy, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
    vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
    vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
    vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);

    vec3 shadow = calcSoftShadow(shadowClipPos);

    vec3 normal = texture(colortex2, texCoord).xyz * 2.0 - 1.0;
    vec2 lightmap = texture(colortex3, texCoord).rg;
    vec3 blocklight = lightmap.r * blocklightColor;
    vec3 ambient = ambientColor;

    vec3 skylight = lightmap.g * skylightColor;
    vec3 lightDir = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);
    vec3 sunlight = sunlightColor * clamp(dot(normal, lightDir), 0.0, 1.0);

    applyShadow(sunlight, shadow);

    applyLightingIntensity(sunlight, sunIntensity);
    applyLightingIntensity(skylight, sunIntensity);

    return blocklight + skylight + ambient + sunlight;
}

void applyLighting(){
    color.rgb = pow(color.rgb, vec3(2.2));
    color.rgb *= calcLighting();
    color.rgb = pow(color.rgb, vec3(1.0 / 2.2));
}

// ----- Main -----

void main()
{
    color = texture(colortex0, texCoord);
    applyLighting();
}