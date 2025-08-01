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
layout(binding = 1, rg32f) uniform highp image2DArray f_arg_0;
vec4 textureLoad_af0507() {
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  ivec2 v_1 = arg_1;
  uint v_2 = arg_2;
  uint v_3 = min(v_2, (uint(imageSize(f_arg_0).z) - 1u));
  uvec2 v_4 = (uvec2(imageSize(f_arg_0).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(v_1), v_4));
  vec4 res = imageLoad(f_arg_0, ivec3(v_5, int(v_3)));
  return res;
}
void main() {
  v.inner = textureLoad_af0507();
}
//
// compute_main
//
#version 460

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 1, rg32f) uniform highp image2DArray arg_0;
vec4 textureLoad_af0507() {
  ivec2 arg_1 = ivec2(1);
  uint arg_2 = 1u;
  ivec2 v_1 = arg_1;
  uint v_2 = arg_2;
  uint v_3 = min(v_2, (uint(imageSize(arg_0).z) - 1u));
  uvec2 v_4 = (uvec2(imageSize(arg_0).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(v_1), v_4));
  vec4 res = imageLoad(arg_0, ivec3(v_5, int(v_3)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_af0507();
}
