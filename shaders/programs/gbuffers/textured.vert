#include "/libs/settings.glsl"

// Attributes

in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec4 vaColor;

// Outputs

out vec2 texCoord;
out vec2 lmCoord;
out vec4 glColor;

// Uniforms

uniform vec2 taaOffset;

uniform mat4 textureMatrix = mat4(1.0);
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// Main

void main(){
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);
    if(TAA == ON){
        gl_Position.xy += taaOffset * gl_Position.w;
    }

    const mat4 TEXTURE_MATRIX_2 = mat4(vec4(0.00390625, 0.0, 0.0, 0.0), vec4(0.0, 0.00390625, 0.0, 0.0), vec4(0.0, 0.0, 0.00390625, 0.0), vec4(0.03125, 0.03125, 0.03125, 1.0));
    lmCoord = (TEXTURE_MATRIX_2 * vec4(vaUV2, 0.0, 1.0)).xy;

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    glColor = vaColor;
}