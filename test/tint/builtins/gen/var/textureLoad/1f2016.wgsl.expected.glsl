//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  vec4 inner;
} v;
layout(binding = 0, std140)
uniform f_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp sampler3D f_arg_0;
vec4 textureLoad_1f2016() {
  ivec3 arg_1 = ivec3(1);
  int arg_2 = 1;
  ivec3 v_2 = arg_1;
  uint v_3 = (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_4 = min(uint(arg_2), v_3);
  uvec3 v_5 = (uvec3(textureSize(f_arg_0, int(v_4))) - uvec3(1u));
  ivec3 v_6 = ivec3(min(uvec3(v_2), v_5));
  vec4 res = texelFetch(f_arg_0, v_6, int(v_4));
  return res;
}
void main() {
  v.inner = textureLoad_1f2016();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  vec4 inner;
} v;
layout(binding = 0, std140)
uniform TintTextureUniformData_1_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp sampler3D arg_0;
vec4 textureLoad_1f2016() {
  ivec3 arg_1 = ivec3(1);
  int arg_2 = 1;
  ivec3 v_2 = arg_1;
  uint v_3 = (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_4 = min(uint(arg_2), v_3);
  uvec3 v_5 = (uvec3(textureSize(arg_0, int(v_4))) - uvec3(1u));
  ivec3 v_6 = ivec3(min(uvec3(v_2), v_5));
  vec4 res = texelFetch(arg_0, v_6, int(v_4));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_1f2016();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  vec4 prevent_dce;
};

layout(binding = 0, std140)
uniform v_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v;
uniform highp sampler3D v_arg_0;
layout(location = 0) flat out vec4 tint_interstage_location0;
vec4 textureLoad_1f2016() {
  ivec3 arg_1 = ivec3(1);
  int arg_2 = 1;
  ivec3 v_1 = arg_1;
  uint v_2 = (v.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_3 = min(uint(arg_2), v_2);
  uvec3 v_4 = (uvec3(textureSize(v_arg_0, int(v_3))) - uvec3(1u));
  ivec3 v_5 = ivec3(min(uvec3(v_1), v_4));
  vec4 res = texelFetch(v_arg_0, v_5, int(v_3));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput v_6 = VertexOutput(vec4(0.0f), vec4(0.0f));
  v_6.pos = vec4(0.0f);
  v_6.prevent_dce = textureLoad_1f2016();
  return v_6;
}
void main() {
  VertexOutput v_7 = vertex_main_inner();
  gl_Position = vec4(v_7.pos.x, -(v_7.pos.y), ((2.0f * v_7.pos.z) - v_7.pos.w), v_7.pos.w);
  tint_interstage_location0 = v_7.prevent_dce;
  gl_PointSize = 1.0f;
}
