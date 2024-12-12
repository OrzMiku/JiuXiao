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

uniform float viewHeight;
uniform float viewWidth;

// Main

void main()
{
    color = texture(colortex0, texCoord);
    if(AGX == ON) {
        color.rgb = agx(color.rgb);
    }
    if(BLUR == ON) {
        color.rgb = gaussianBlur(colortex0, texCoord, vec2(viewWidth, viewHeight), BLUR_RADIUS, BLUR_SIGMA);
    }
}