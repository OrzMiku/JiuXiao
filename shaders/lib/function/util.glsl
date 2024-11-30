// ----- Utility functions -----

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
    vec4 clipSpace = projectionMatrix * vec4(position, 1.0);
    vec3 ndcSpace = clipSpace.xyz / clipSpace.w;
    return ndcSpace;
}

float expDecay(float a, float b){
    return exp(-a * (1.0-b));
}