
// ----- Layout -----

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 color;

// ----- Uniform -----

uniform float fogStart;
uniform float fogEnd;

uniform vec3 fogColor;

uniform sampler2D colortex0;

// ----- Input -----

in float dist;

in vec2 texCoord;
in vec4 glColor;

// ----- Main -----

void main(){
    color = texture(colortex0, texCoord) * glColor;

    // Fog
    float fogIntensity = clamp((dist - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
    color.rgb = mix(color.rgb, fogColor, fogIntensity);

    if(color.a < 0.1) discard;
}