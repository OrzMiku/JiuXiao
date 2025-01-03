// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

#ifdef ENTITIES
    uniform vec4 entityColor;
#endif

// Outputs
out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 tint;

// Main
void main(){
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    if(TAA) gl_Position.xy += taaOffset * gl_Position.w;
    
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    
    lmCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    lmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32.0);
    
    normal = mat3(gbufferModelViewInverse) * gl_NormalMatrix * gl_Normal;

    tint = gl_Color;
    #ifdef ENTITIES
        tint.rgb = mix(tint.rgb, tint.rgb, vec3(tint.a));
    #endif
}