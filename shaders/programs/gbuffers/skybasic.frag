// Uniforms
#include "/libs/uniforms.glsl"

// Inputs
in vec4 glColor;

// Outputs
/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Functions
#include "/libs/functions.glsl"

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, upPosition) * 0.02;
	return mix(skyColor, fogColor * clamp(sunIntensity, 0.0, 1.0), fogify(max(upDot, 0.0), 0.25));
}

// Main
void main(){
    if(renderStage == MC_RENDER_STAGE_STARS){
        color = glColor;
    }else{
        vec3 pos = screenToView(vec3(gl_FragCoord.xy * texelSize, 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
    }

    if(color.a < alphaTestRef){
        discard;
    }
}