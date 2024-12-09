#include "/libs/functions.glsl"

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Inputs

in vec2 texCoord;

// Uniforms

uniform sampler2D colortex0;

// Main

void main()
{
    color = texture(colortex0, texCoord);
}