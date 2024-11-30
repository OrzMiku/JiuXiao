// ----- Parameters -----

#define SHADOW_QUALITY 2.0
#define SHADOW_SOFTNESS 1.0

// ----- Constants -----

const float shadowMapResolution = 2048.0;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowcolor0Nearest = true;

vec3 distortShadowClipPos(vec3 shadowClipPos){
  float distortionFactor = length(shadowClipPos.xy);
  distortionFactor += 0.1;
  shadowClipPos.xy /= distortionFactor;
  shadowClipPos.z *= 0.5;
  return shadowClipPos;
}