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

layout(binding = 0, rgba16_snorm) uniform highp writeonly image2DArray f_arg_0;
void textureStore_6b7c6f() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  vec4 arg_3 = vec4(1.0f);
  uint v = arg_2;
  vec4 v_1 = arg_3;
  ivec2 v_2 = ivec2(arg_1);
  imageStore(f_arg_0, ivec3(v_2, int(v)), v_1);
}
void main() {
  textureStore_6b7c6f();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, rgba16_snorm) uniform highp writeonly image2DArray arg_0;
void textureStore_6b7c6f() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  vec4 arg_3 = vec4(1.0f);
  uint v = arg_2;
  vec4 v_1 = arg_3;
  ivec2 v_2 = ivec2(arg_1);
  imageStore(arg_0, ivec3(v_2, int(v)), v_1);
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  textureStore_6b7c6f();
}

tint executable returned error: exit status 1
