#include "/libs/settings.glsl"
#include "/libs/functions.glsl"
#include "/libs/tonemap/agx.glsl"

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Inputs

in vec2 texCoord;

// Uniforms

uniform sampler2D colortex0;

uniform vec2 screenSize;

// Main

void main()
{
    color = texture(colortex0, texCoord);
    if(BLUR == ON) {
        color.rgb = gaussianBlur(colortex0, texCoord, screenSize, BLUR_RADIUS, BLUR_SIGMA);
    }
    if(AGX == ON) {
        color.rgb = agx(color.rgb);
    }
}