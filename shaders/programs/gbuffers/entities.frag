// Inputs

in vec2 texCoord;
in vec2 lmCoord;
in vec3 normal;
in vec4 glColor;

// Uniforms

#include "/libs/uniforms.glsl"

// Outputs

/* RENDERTARGETS: 0,2,3 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 encodedNormal;
layout(location = 2) out vec4 lightmapData;

void main(){
    color = texture(gtexture, texCoord) * glColor;    
    color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);

    color *= texture(lightmap, lmCoord);

    encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
    lightmapData = vec4(lmCoord, 0.0, 1.0);
    if(color.a < alphaTestRef){
        discard;
    }
}