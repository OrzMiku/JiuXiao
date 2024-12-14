#include "/libs/settings.glsl"

// Uniforms
#include "/libs/uniforms.glsl"

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Inputs
in vec2 texCoord;

// Functions
#include "/libs/functions.glsl"
#include "/libs/tonemap/agx.glsl"

// Main
void main()
{
    color = texture(colortex0, texCoord);
    if(BLUR) {
        #ifdef BLUR_H
            color.rgb = gaussianBlur_H(colortex0, texCoord, screenSize, BLUR_RADIUS, BLUR_SIGMA);
        #endif
        #ifdef BLUR_V
            color.rgb = gaussianBlur_V(colortex0, texCoord, screenSize, BLUR_RADIUS, BLUR_SIGMA);
        #endif
    }
    if(AGX) {
        color.rgb = agx(color.rgb);
    }
}