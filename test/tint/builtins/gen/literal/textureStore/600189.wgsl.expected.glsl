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

layout(binding = 0, r16) uniform highp writeonly image3D f_arg_0;
void textureStore_600189() {
  imageStore(f_arg_0, ivec3(1), vec4(1.0f));
}
void main() {
  textureStore_600189();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, r16) uniform highp writeonly image3D arg_0;
void textureStore_600189() {
  imageStore(arg_0, ivec3(1), vec4(1.0f));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_600189();
}

tint executable returned error: exit status 1
