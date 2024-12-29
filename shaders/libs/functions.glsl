vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

vec3 screenToView(vec3 screenPos) {
	vec3 ndcPos = screenPos * 2.0 - 1.0;
    return projectAndDivide(gbufferProjectionInverse, ndcPos);
}

float luminance(vec3 color){
  return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

vec3 gaussianBlur(sampler2D src, vec2 uv, vec2 resolution, float radius, float sigma){
  vec3 color = vec3(0.0);
  float total = 0.0;
  for(float x = -radius; x <= radius; x++){
    for(float y = -radius; y <= radius; y++){
      float weight = exp(-(x * x + y * y) / (2.0 * sigma * sigma));
      vec2 samplePos = uv + vec2(x, y) / resolution;
      color += texture2D(src, samplePos).rgb * weight;
      total += weight;
    }
  }
  return color / total;
}