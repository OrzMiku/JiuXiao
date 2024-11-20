#version 450 core

// ----- Input -----
in vec2 texCoord;

// ----- Uniforms -----
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 fragColor;

// ----- Constants -----
const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0);
const vec3 ambientColor = vec3(0.1);

// ----- Functions -----

vec3 calculateLighting(vec3 normal){
    vec3 blocklight = texture(colortex1, texCoord).r * blocklightColor;
    vec3 skylight = texture(colortex2, texCoord).g * skylightColor;
    vec3 ambient = ambientColor;
    vec3 lightVector = normalize(shadowLightPosition);
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;
    float lightDot = max(dot(normal, worldLightVector), 0.0);
    return blocklight + skylight + ambient + sunlightColor * lightDot;
}

void main(){
    fragColor = texture(colortex0, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    if(depth == 1.0) return;
    vec3 normal = texture(colortex2, texCoord).rgb * 2.0 - 1.0;
    vec3 lighting = calculateLighting(normal);
    fragColor.rgb *= lighting;
}