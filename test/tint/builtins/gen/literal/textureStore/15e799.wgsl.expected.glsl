SKIP: FAILED

Error parsing GLSL shader:
ERROR: 0:5: 'image load-store format' : not supported with this profile: es
ERROR: 0:5: '' : compilation terminated 
ERROR: 2 compilation errors.  No code generated.



Error parsing GLSL shader:
ERROR: 0:3: 'image load-store format' : not supported with this profile: es
ERROR: 0:3: '' : compilation terminated 
ERROR: 2 compilation errors.  No code generated.



//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, r8i) uniform highp writeonly iimage2D f_arg_0;
void textureStore_15e799() {
  imageStore(f_arg_0, ivec2(1), ivec4(1));
}
void main() {
  textureStore_15e799();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, r8i) uniform highp writeonly iimage2D arg_0;
void textureStore_15e799() {
  imageStore(arg_0, ivec2(1), ivec4(1));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_15e799();
}

tint executable returned error: exit status 1
