// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Constants
const float ambientIntensity = 0.03;
const float specularIntensity = 0.5;
const vec3 shadowLightColor = vec3(1.0);
const vec3 skyLightColor = vec3(0.10, 0.20, 0.3);
const vec3 blockLightColor = vec3(1.0, 0.5, 0.08); 

// Inputs
in vec2 texCoord;

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions
#include "/libs/functions.glsl"

vec3 getNoise(ivec2 texelCoord){
    vec2 noiseCoord = texelCoord % noiseTextureResolution;
    return texture(noisetex, noiseCoord / noiseTextureResolution).rgb;
}

vec3 getShadow(vec3 shadowScreenPos){
    float currentDepth = shadowScreenPos.z;

    float transparentClosestDepth = texture(shadowtex0, shadowScreenPos.xy).r;
    float transparentShadow = currentDepth > transparentClosestDepth ? 0.0 : 1.0;
    if(transparentShadow == 1.0) return vec3(1.0);

    float opaqueClosestDepth = texture(shadowtex1, shadowScreenPos.xy).r;
    float opaqueShadow = currentDepth > opaqueClosestDepth ? 0.0 : 1.0;
    if(opaqueShadow == 0.0) return vec3(0.0);

    vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);
    return shadowColor.rgb * (1 - shadowColor.a);
}

vec3 getSoftShadow(vec4 shadowClipPos, float bias){


    const float sampleRadius = SHADOW_SOFTNESS / 2.0;
    const float sampleStep = sampleRadius / SHADOW_QUALITY;

    float noise = getNoise(ivec2(texCoord * screenSize)).r;
    float theta = noise * radians(360.0);
    float cosTheta = cos(theta);
    float sinTheta = sin(theta);
    mat2 rotation = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);

    vec3 shadowAccum = vec3(0.0);
    int sampleCount = 0;

    for(float i = -sampleRadius; i <= sampleRadius; i += sampleStep){
        for(float j = -sampleRadius; j <= sampleRadius; j += sampleStep){
            vec2 offset = vec2(i, j) * rotation / shadowMapResolution;
            vec4 offsetShadowClipPos = shadowClipPos + vec4(offset, 0.0, 0.0);
            offsetShadowClipPos.xyz = distortShadowClipPos(offsetShadowClipPos.xyz);
            offsetShadowClipPos.z -= bias;
            vec3 shadowNDCPos = offsetShadowClipPos.xyz / offsetShadowClipPos.w;
            vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;
            shadowAccum += getShadow(shadowScreenPos);
            sampleCount++;
        }
    }

    return shadowAccum / float(sampleCount);
}

// Main
void main(){
    color = texture(colortex0, texCoord);

    if(WHITE_WORLD) color.rgb = vec3(1.0);
    float depth = texture(depthtex0, texCoord).r;
    vec3 viewPos = screenToView(texCoord, depth);
    vec3 feetPlayerPos = viewToFeetPlayer(viewPos);
    vec3 shadowViewPos = feetPlayerToShadowView(feetPlayerPos);

    // Sky
    if(depth == 1.0) return;
    
    // Read normal and lmCoord
    vec3 normal = texture(colortex1, texCoord).xyz * 2.0 - 1.0;
    vec2 lightmap = texture(colortex2, texCoord).rg;
    lightmap = pow(lightmap, vec2(2.2));

    // World time
    float lightIntensity = 0.0;
    if(worldTime >= 23000 && worldTime < 24000) {
        lightIntensity = (24000 - worldTime) / 1000.0;
    }else if(worldTime >= 0 && worldTime < 12000) {
        lightIntensity = 1.0;
    }else if(worldTime >= 12000 && worldTime < 13000) {
        lightIntensity = 1.0 - (worldTime - 12000) / 1000.0;
    }else if(worldTime >= 13000 && worldTime < 23000) {
        lightIntensity = 0.0;
    }

    lightIntensity = 0.1 + lightIntensity * 0.9;

    // Diffuse lighting
    vec3 lightDir = normalize(viewToFeetPlayer(shadowLightPosition));
    float NdotL = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = shadowLightColor * NdotL;

    // Specular lighting
    vec3 viewDir = normalize(-feetPlayerPos);
    vec3 halfDir = normalize(lightDir + viewDir);
    float NdotH = max(dot(normal, halfDir), 0.0);
    float spec = pow(NdotH, 8.0);
    vec3 specular = shadowLightColor * spec * specularIntensity;

    // Ambient lighting
    vec3 ambient = vec3(0.0);
    ambient += color.rgb * ambientIntensity;

    // Sky light
    ambient += skyLightColor * lightmap.g * lightIntensity;

    // Block light
    ambient += blockLightColor * lightmap.r;

    // Shadow
    vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
    float dist = length(feetPlayerPos) / far;
    float bias = max(0.0005 * (1.0 - dot(normal, lightDir)), 0.00005) + 0.05 * exp(-8 * (1.0 - dist));
    vec3 shadow = getSoftShadow(shadowClipPos, bias);

    // Final color
    color.rgb *= ambient + lightIntensity * (diffuse + specular) * shadow;

    color *= lightIntensity;

    // Gamma correction
    color.rgb = pow(color.rgb, vec3(1.0 / 2.2));
}