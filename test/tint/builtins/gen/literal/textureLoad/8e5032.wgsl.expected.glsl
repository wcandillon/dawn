//
// fragment_main
//
#version 460
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  uvec4 inner;
} v;
layout(binding = 1, rg32ui) uniform highp readonly uimage2DArray f_arg_0;
uvec4 textureLoad_8e5032() {
  uint v_1 = (uint(imageSize(f_arg_0).z) - 1u);
  uint v_2 = min(uint(1), v_1);
  uvec2 v_3 = (uvec2(imageSize(f_arg_0).xy) - uvec2(1u));
  ivec2 v_4 = ivec2(min(uvec2(ivec2(1)), v_3));
  uvec4 res = imageLoad(f_arg_0, ivec3(v_4, int(v_2)));
  return res;
}
void main() {
  v.inner = textureLoad_8e5032();
}
//
// compute_main
//
#version 460

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 1, rg32ui) uniform highp readonly uimage2DArray arg_0;
uvec4 textureLoad_8e5032() {
  uint v_1 = (uint(imageSize(arg_0).z) - 1u);
  uint v_2 = min(uint(1), v_1);
  uvec2 v_3 = (uvec2(imageSize(arg_0).xy) - uvec2(1u));
  ivec2 v_4 = ivec2(min(uvec2(ivec2(1)), v_3));
  uvec4 res = imageLoad(arg_0, ivec3(v_4, int(v_2)));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_8e5032();
}
//
// vertex_main
//
#version 460


struct VertexOutput {
  vec4 pos;
  uvec4 prevent_dce;
};

layout(binding = 0, rg32ui) uniform highp readonly uimage2DArray v_arg_0;
layout(location = 0) flat out uvec4 tint_interstage_location0;
uvec4 textureLoad_8e5032() {
  uint v = (uint(imageSize(v_arg_0).z) - 1u);
  uint v_1 = min(uint(1), v);
  uvec2 v_2 = (uvec2(imageSize(v_arg_0).xy) - uvec2(1u));
  ivec2 v_3 = ivec2(min(uvec2(ivec2(1)), v_2));
  uvec4 res = imageLoad(v_arg_0, ivec3(v_3, int(v_1)));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput v_4 = VertexOutput(vec4(0.0f), uvec4(0u));
  v_4.pos = vec4(0.0f);
  v_4.prevent_dce = textureLoad_8e5032();
  return v_4;
}
void main() {
  VertexOutput v_5 = vertex_main_inner();
  gl_Position = vec4(v_5.pos.x, -(v_5.pos.y), ((2.0f * v_5.pos.z) - v_5.pos.w), v_5.pos.w);
  tint_interstage_location0 = v_5.prevent_dce;
  gl_PointSize = 1.0f;
}
