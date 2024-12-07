vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

vec3 screenToView(mat4 projectionInverse, vec3 screenPos){
  vec3 NDCPos = screenPos * 2.0 - 1.0;
  vec3 viewPos = projectAndDivide(projectionInverse, NDCPos);
  return viewPos;
}