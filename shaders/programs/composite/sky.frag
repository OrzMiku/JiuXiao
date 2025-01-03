// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Inputs
in vec2 texCoord;

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions
#include "/libs/functions.glsl"

float drawSun(vec3 rayDir, vec3 lightDir) {
    float cosAngle = max(dot(rayDir, lightDir), 0.0);
    const float sunRadius = 0.02;
    float theta = acos(cosAngle);
    return theta > sunRadius ? exp(-128.0 * (theta - sunRadius)) : 1.0;
}

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 drawSky(vec3 pos) {
	float upDot = dot(pos, upPosition) * 0.02;
	return mix(skyColor, fogColor * clamp(sunIntensity, 0.0, 1.0), fogify(max(upDot, 0.0), 0.25));
}

// Main
void main(){
    color = texture(colortex0, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    vec3 viewPos = screenToView(texCoord, depth);
    vec3 rayDir = normalize(viewPos);
    vec3 lightDir = normalize(shadowLightPosition);

    if(depth == 1.0) {
        vec4 star = texture(colortex3, texCoord);
        color.rgb = drawSky(rayDir);
        color += pow(star, vec4(1.0 / 2.2));
        color.rgb = mix(color.rgb, vec3(1.0), drawSun(rayDir, lightDir));
        return;
    }
}