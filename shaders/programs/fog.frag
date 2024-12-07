
// ----- Define -----

#define FOG_DENSITY 5.0

// ----- Layout -----

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 color;

// ----- Uniform -----

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform float sunIntensity;
uniform float far;

uniform vec3 fogcolor;
uniform vec3 skyColor;
uniform vec3 upPosition;

uniform mat4 gbufferProjectionInverse;

// ----- Input -----

in vec2 texCoord;
in vec4 glColor;

// ----- Include -----

#include "/lib/function.glsl"

// ----- Function -----

float calcFogFactor(vec3 viewPos){
    float dist = length(viewPos) / far;
    float density = FOG_DENSITY;
    return exp(-density * (1.0 - dist));
}

vec3 calcSkyColor(vec3 viewPos){
    float up = dot(normalize(viewPos), upPosition) / 100;
    return mix(fogcolor * normalize(sunIntensity), skyColor, clamp(up, 0.0, 1.0));
}

// ----- Main -----

void main(){
    color = texture(colortex0, texCoord) * glColor;

    float depth = texture(depthtex0, texCoord).r;

    vec3 NDCPos = vec3(texCoord.xy, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);

    float fogFactor = calcFogFactor(viewPos);
    color.rgb = mix(color.rgb, fogcolor * normalize(sunIntensity), clamp(fogFactor, 0.0, 1.0));

    if(depth == 1.0) color.rgb = calcSkyColor(viewPos);

    if(color.a < 0.1) discard;
}