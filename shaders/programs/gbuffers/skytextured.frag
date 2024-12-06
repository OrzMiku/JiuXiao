
// ----- Layout -----

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 color;

// ----- Uniform -----

uniform sampler2D colortex0;

// ----- Input -----

in vec2 texCoord;

in vec4 glColor;

// ----- Main -----

void main(){
    color = texture(colortex0, texCoord) * glColor;

    if(color.a < 0.1) discard;
}