
// ----- Constants -----

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 ambientColor = vec3(0.1);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0, 0.9, 0.8);

// ----- Layout -----

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

// ----- Uniform -----

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D depthtex0;

uniform float sunIntensity;

uniform vec3 shadowLightPosition;

uniform mat4 gbufferModelViewInverse;

// ----- Input -----

in vec2 texCoord;

// ----- Functions -----

vec3 calcLighting(){
    vec3 normal = texture(colortex3, texCoord).xyz * 2.0 - 1.0;
    vec2 lightmap = texture(colortex2, texCoord).rg;
    vec3 blocklight = lightmap.r * blocklightColor;
    vec3 ambient = ambientColor;

    vec3 skylight = lightmap.g * skylightColor;
    vec3 lightDir = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);
    vec3 sunlight = sunlightColor * clamp(dot(normal, lightDir), 0.0, 1.0) * lightmap.g;

    sunlight *= sunIntensity;
    skylight *= sunIntensity;

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
    float depth = texture(depthtex0, texCoord).r;

    // Lighting
    applyLighting();
}