// ----- Tone Mapping -----

#include "/lib/settings.glsl"
#include "/lib/agx.glsl"

// ----- Layout -----

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

// ----- Uniform -----

uniform sampler2D colortex0;

// ----- Input -----

in vec2 texCoord;

// ----- Main -----

void main()
{
    color = texture(colortex0, texCoord);
    if(AGX == 1) color.rgb = agx(color.rgb);
}