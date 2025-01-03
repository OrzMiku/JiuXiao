uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D noisetex;
uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform int worldTime;
uniform int renderStage;
uniform int frameIndex;
uniform int viewHeight;

uniform float alphaTestRef;
uniform float far;
uniform float sunIntensity;
uniform float jitterX;
uniform float jitterY;

uniform vec2 screenSize;
uniform vec2 texelSize;
uniform vec2 taaOffset;

uniform vec3 chunkOffset;
uniform vec3 shadowLightPosition;
uniform vec3 upPosition;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform vec3 cameraMovement;
uniform vec3 cameraPosition;

uniform mat4 textureMatrix;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;