// LIGHTING
const float sunPathRotation = -40.0; // [-90.0 -85.0 -80.0 -75.0 -70.0 -65.0 -60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 80.0 85.0 90.0]

// SHADOW
#define SHADOW_QUALITY 2 // [1 2 4 8]
#define SHADOW_SOFTNESS 1 // [1 2 4]
const int shadowMapResolution = 2048; // [512 1024 2048 4096]

// POST
#define TAA true // [true false]

// DEBUG
#define WHITE_WORLD false // [true false]
const int noiseTextureResolution = 256; // [64 128 256 512 1024]

const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowcolor0Nearest = true;