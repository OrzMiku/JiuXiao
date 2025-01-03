// Settings
#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Inputs
in vec4 tint;

// Outputs
/* RENDERTARGETS: 3 */
layout(location = 0) out vec4 color;

// Main
void main(){
    if(renderStage == MC_RENDER_STAGE_STARS){
        color = tint;
    }else{
        return;
    }

    // Alpha test
    if(color.a < alphaTestRef){
        discard;
    }

    // Gamma correction
    color.rgb = pow(color.rgb, vec3(2.2));
}