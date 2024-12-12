const int shadowMapResolution = 2048;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowcolor0Nearest = true;

vec3 distortShadowClipPos(vec3 shadowClipPos){
  float distortionFactor = length(shadowClipPos.xy); // distance from the player in shadow clip space
  distortionFactor += 0.1; // very small distances can cause issues so we add this to slightly reduce the distortion

  shadowClipPos.xy /= distortionFactor;
  shadowClipPos.z *= 0.25; // increases shadow distance on the Z axis, which helps when the sun is very low in the sky
  return shadowClipPos;
}

#ifdef SHADOW_FRAG

vec4 getNoise(vec2 coord){
  ivec2 screenCoord = ivec2(coord * screenSize);
  ivec2 noiseCoord = screenCoord % 64;
  return texelFetch(noisetex, noiseCoord, 0);
}

vec3 getShadow(vec3 shadowScreenPos){
    float transparentShadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r); // sample the shadow map containing everything
    if(transparentShadow == 1.0){
        return vec3(1.0);
    }

    float opaqueShadow = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r); // sample the shadow map containing only opaque stuff
    if(opaqueShadow == 0.0){
        return vec3(0.0);
    }

    vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);
    return shadowColor.rgb * (1 - shadowColor.a);
}

vec3 PCF(vec4 shadowClipPos, float bias){
    const float range = SHADOW_SOFTNESS / 2.0;
    const float increment = range / SHADOW_QUALITY;

    float noise = getNoise(texCoord).r;
    float theta = noise * radians(360.0);
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);

    vec3 shadowAccum = vec3(0.0);
    float totalWeight = 0.0;

    for(float x = -range; x <= range; x += increment){
        for (float y = -range; y <= range; y += increment){
            vec2 offset = rotation * vec2(x, y) / shadowMapResolution;
            vec4 offsetShadowClipPos = shadowClipPos + vec4(offset, 0.0, 0.0);
            offsetShadowClipPos.xyz = distortShadowClipPos(offsetShadowClipPos.xyz);
            offsetShadowClipPos.z -= bias;
            vec3 shadowNDCPos = offsetShadowClipPos.xyz / offsetShadowClipPos.w;
            vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;
            float weight = exp(-(x*x + y*y) / (2.0 * range * range));
            shadowAccum += getShadow(shadowScreenPos) * weight;
            totalWeight += weight;
        }
    }

    return shadowAccum / totalWeight;
}

#endif