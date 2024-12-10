#include "/libs/functions.glsl"

// Inputs

in vec4 glColor;

// Uniforms

uniform int renderStage;
uniform float sunIntensity;
uniform float viewWidth;
uniform float viewHeight;
uniform float alphaTestRef;

uniform vec3 upPosition;
uniform vec3 skyColor;
uniform vec3 fogColor;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;

// Outputs

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions

vec3 screenToView(vec3 screenPos) {
	vec3 ndcPos = screenPos * 2.0 - 1.0;
    return projectAndDivide(gbufferProjectionInverse, ndcPos);
}

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, upPosition) * 0.02;
	return mix(skyColor, fogColor * clamp(sunIntensity, 0.0, 1.0), fogify(max(upDot, 0.0), 0.25));
}

void main(){
    if(renderStage == MC_RENDER_STAGE_STARS){
        color = glColor;
    }else{
        vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
    }

    if(color.a < alphaTestRef){
        discard;
    }
}