//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  ivec4 inner;
} v;
layout(binding = 1, rgba16i) uniform highp readonly iimage2D f_arg_0;
ivec4 textureLoad_2ae485() {
  ivec2 arg_1 = ivec2(1);
  ivec2 v_1 = arg_1;
  uvec2 v_2 = (uvec2(imageSize(f_arg_0)) - uvec2(1u));
  ivec4 res = imageLoad(f_arg_0, ivec2(min(uvec2(v_1), v_2)));
  return res;
}
void main() {
  v.inner = textureLoad_2ae485();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  ivec4 inner;
} v;
layout(binding = 1, rgba16i) uniform highp readonly iimage2D arg_0;
ivec4 textureLoad_2ae485() {
  ivec2 arg_1 = ivec2(1);
  ivec2 v_1 = arg_1;
  uvec2 v_2 = (uvec2(imageSize(arg_0)) - uvec2(1u));
  ivec4 res = imageLoad(arg_0, ivec2(min(uvec2(v_1), v_2)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_2ae485();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  ivec4 prevent_dce;
};

layout(binding = 0, rgba16i) uniform highp readonly iimage2D v_arg_0;
layout(location = 0) flat out ivec4 tint_interstage_location0;
ivec4 textureLoad_2ae485() {
  ivec2 arg_1 = ivec2(1);
  ivec2 v = arg_1;
  uvec2 v_1 = (uvec2(imageSize(v_arg_0)) - uvec2(1u));
  ivec4 res = imageLoad(v_arg_0, ivec2(min(uvec2(v), v_1)));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput v_2 = VertexOutput(vec4(0.0f), ivec4(0));
  v_2.pos = vec4(0.0f);
  v_2.prevent_dce = textureLoad_2ae485();
  return v_2;
}
void main() {
  VertexOutput v_3 = vertex_main_inner();
  gl_Position = vec4(v_3.pos.x, -(v_3.pos.y), ((2.0f * v_3.pos.z) - v_3.pos.w), v_3.pos.w);
  tint_interstage_location0 = v_3.prevent_dce;
  gl_PointSize = 1.0f;
}
