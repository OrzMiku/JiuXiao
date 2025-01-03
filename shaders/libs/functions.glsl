vec3 projectAndDivide(mat4 projection, vec3 pos) {
    vec4 clip = projection * vec4(pos, 1.0);
    return clip.xyz / clip.w;
}

vec3 screenToView(vec2 screenPos, float depth) {
    vec3 NDCPos = vec3(screenPos, depth) * 2.0 - 1.0;
    return projectAndDivide(gbufferProjectionInverse, NDCPos);
}

vec3 viewToFeetPlayer(vec3 viewPos) {
    return (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
}

vec3 viewToEyePlayer(vec3 viewPos) {
    return mat3(gbufferModelViewInverse) * viewPos;
}

vec3 feetPlayerToShadowView(vec3 feetPlayerPos) {
    return (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
}

vec3 distortShadowClipPos(vec3 shadowClipPos) {
    float dist = length(shadowClipPos.xy);
    float distortionFactor = dist * 0.9 + 0.1;
    shadowClipPos.xy /= distortionFactor;
    shadowClipPos.z *= 0.25;
    return shadowClipPos;
}