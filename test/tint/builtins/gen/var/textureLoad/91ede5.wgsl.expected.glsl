//
// fragment_main
//
#version 460
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  vec4 inner;
} v;
layout(binding = 1, rg32f) uniform highp image3D f_arg_0;
vec4 textureLoad_91ede5() {
  uvec3 arg_1 = uvec3(1u);
  uvec3 v_1 = arg_1;
  vec4 res = imageLoad(f_arg_0, ivec3(min(v_1, (uvec3(imageSize(f_arg_0)) - uvec3(1u)))));
  return res;
}
void main() {
  v.inner = textureLoad_91ede5();
}
//
// compute_main
//
#version 460

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 1, rg32f) uniform highp image3D arg_0;
vec4 textureLoad_91ede5() {
  uvec3 arg_1 = uvec3(1u);
  uvec3 v_1 = arg_1;
  vec4 res = imageLoad(arg_0, ivec3(min(v_1, (uvec3(imageSize(arg_0)) - uvec3(1u)))));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_91ede5();
}
