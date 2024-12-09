// Inputs

in float lightIntensity;
in vec2 texCoord;
in vec2 lmCoord;
in vec4 glColor;

// Uniforms

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform float alphaTestRef;

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main(){
    color = texture(gtexture, texCoord) * glColor;
    color *= texture(lightmap, lmCoord);
    color.rgb *= lightIntensity;
    if(color.a < alphaTestRef){
        discard;
    }
}