vec3 exposure(vec3 color, float factor) {
    float skylight = float(eyeBrightnessSmooth.y) / 240;
    skylight = pow(skylight, 6.0) * factor + (1.0f - factor);
    return color / skylight;
}

vec3 calcLighting(vec3 color){
    float depth = texture(depthtex0, texCoord).r;
    if(depth == 1.0) return vec3(1.0);
    vec3 NDCPos = vec3(texCoord.xy, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
    vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
    vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
    vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);

    vec3 normal = texture(colortex2, texCoord).xyz * 2.0 - 1.0;
    vec3 lightDir = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);

    float dist = length(feetPlayerPos) / far;
    float bias = max(0.0005 * (1.0 - dot(normal, normalize(lightDir))), 0.00005) + 0.05 * exp(-8 * (1.0 - dist));

    vec3 shadow = PCF(shadowClipPos, bias);

    vec2 lightmap = texture(colortex3, texCoord).rg;
    vec3 blocklight = lightmap.r * blocklightColor;
    vec3 ambient = ambientColor;
    vec3 skylight = lightmap.g * skylightColor;
    vec3 diffuse = sunlightColor * clamp(dot(normal, lightDir), 0.0, 1.0);
    
    vec3 viewDir = normalize(-feetPlayerPos);
    vec3 halfDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfDir), 0.0), 8.0);
    vec3 specular = sunIntensity * spec * sunlightColor;
    vec3 sunlight = diffuse + specular;

    sunlight *= sunIntensity * shadow;
    skylight *= sunIntensity;

    return (blocklight + skylight + ambient + sunlight);
}

void applyLighting(){
    color.rgb = pow(color.rgb, vec3(2.2));
    color.rgb *= calcLighting(color.rgb);
    color.rgb = exposure(color.rgb, 0.7);
    color.rgb = pow(color.rgb, vec3(1.0 / 2.2));
}