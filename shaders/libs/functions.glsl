vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

float HUE2RGB(float p, float q, float t){
  if(t < 0.0){
    t += 360.0;
  }else if(t > 360.0){
    t -= 360.0;
  }
  
  if(t < 60.0){
    return p + (q - p) * t / 60.0;
  }else if(t < 180.0){
    return q;
  }else if(t < 240.0){
    return p + (q - p) * (240.0 - t) / 60.0;
  }else{
    return p;
  }
}

vec3 RGB2HSL(vec3 RGB){
  vec3 HSL;
  float maxC = max(max(RGB.r, RGB.g), RGB.b);
  float minC = min(min(RGB.r, RGB.g), RGB.b);
  float delta = maxC - minC;
  
  HSL.z = (maxC + minC) / 2.0;
  
  if(delta == 0.0){
    HSL.x = 0.0;
    HSL.y = 0.0;
  }else{
    if(HSL.z < 0.5){
      HSL.y = delta / (maxC + minC);
    }else{
      HSL.y = delta / (2.0 - maxC - minC);
    }
    
    if(RGB.r == maxC){
      HSL.x = (RGB.g - RGB.b) / delta;
    }else if(RGB.g == maxC){
      HSL.x = 2.0 + (RGB.b - RGB.r) / delta;
    }else{
      HSL.x = 4.0 + (RGB.r - RGB.g) / delta;
    }
    
    HSL.x *= 60.0;
    if(HSL.x < 0.0){
      HSL.x += 360.0;
    }
  }
  
  return HSL;
}

vec3 HSL2RGB(vec3 HSL){
  vec3 RGB;
  
  if(HSL.y == 0.0){
    RGB = vec3(HSL.z);
  }else{
    float q;
    if(HSL.z < 0.5){
      q = HSL.z * (1.0 + HSL.y);
    }else{
      q = HSL.z + HSL.y - HSL.z * HSL.y;
    }
    
    float p = 2.0 * HSL.z - q;
    
    RGB.r = HUE2RGB(p, q, HSL.x + 120.0);
    RGB.g = HUE2RGB(p, q, HSL.x);
    RGB.b = HUE2RGB(p, q, HSL.x - 120.0);
  }
  
  return RGB;
}

vec3 RGB2HSV(vec3 RGB){
  vec3 HSV;
  float maxC = max(max(RGB.r, RGB.g), RGB.b);
  float minC = min(min(RGB.r, RGB.g), RGB.b);
  float delta = maxC - minC;
  
  HSV.z = maxC;
  
  if(delta == 0.0){
    HSV.x = 0.0;
    HSV.y = 0.0;
  }else{
    if(HSV.z == 0.0){
      HSV.y = 0.0;
    }else{
      HSV.y = delta / HSV.z;
    }
    
    if(RGB.r == HSV.z){
      HSV.x = (RGB.g - RGB.b) / delta;
    }else if(RGB.g == HSV.z){
      HSV.x = 2.0 + (RGB.b - RGB.r) / delta;
    }else{
      HSV.x = 4.0 + (RGB.r - RGB.g) / delta;
    }
    
    HSV.x *= 60.0;
    if(HSV.x < 0.0){
      HSV.x += 360.0;
    }
  }
  
  return HSV;
}

vec3 HSV2RGB(vec3 HSV){
  vec3 RGB;
  
  if(HSV.y == 0.0){
    RGB = vec3(HSV.z);
  }else{
    float h = HSV.x / 60.0;
    int i = int(h);
    float f = h - float(i);
    float p = HSV.z * (1.0 - HSV.y);
    float q = HSV.z * (1.0 - HSV.y * f);
    float t = HSV.z * (1.0 - HSV.y * (1.0 - f));
    
    if(i == 0){
      RGB = vec3(HSV.z, t, p);
    }else if(i == 1){
      RGB = vec3(q, HSV.z, p);
    }else if(i == 2){
      RGB = vec3(p, HSV.z, t);
    }else if(i == 3){
      RGB = vec3(p, q, HSV.z);
    }else if(i == 4){
      RGB = vec3(t, p, HSV.z);
    }else{
      RGB = vec3(HSV.z, p, q);
    }
  }
  
  return RGB;
}