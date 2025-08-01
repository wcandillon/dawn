//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  float inner;
} v;
layout(binding = 0, std140)
uniform f_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp sampler2DArray f_arg_0;
float textureLoad_c16e00() {
  uint v_2 = min(1u, (uint(textureSize(f_arg_0, 0).z) - 1u));
  uint v_3 = (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_4 = min(uint(1), v_3);
  uvec2 v_5 = (uvec2(textureSize(f_arg_0, int(v_4)).xy) - uvec2(1u));
  ivec2 v_6 = ivec2(min(uvec2(ivec2(1)), v_5));
  ivec3 v_7 = ivec3(v_6, int(v_2));
  float res = texelFetch(f_arg_0, v_7, int(v_4)).x;
  return res;
}
void main() {
  v.inner = textureLoad_c16e00();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  float inner;
} v;
layout(binding = 0, std140)
uniform TintTextureUniformData_1_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp sampler2DArray arg_0;
float textureLoad_c16e00() {
  uint v_2 = min(1u, (uint(textureSize(arg_0, 0).z) - 1u));
  uint v_3 = (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_4 = min(uint(1), v_3);
  uvec2 v_5 = (uvec2(textureSize(arg_0, int(v_4)).xy) - uvec2(1u));
  ivec2 v_6 = ivec2(min(uvec2(ivec2(1)), v_5));
  ivec3 v_7 = ivec3(v_6, int(v_2));
  float res = texelFetch(arg_0, v_7, int(v_4)).x;
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_c16e00();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  float prevent_dce;
};

layout(binding = 0, std140)
uniform v_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v;
uniform highp sampler2DArray v_arg_0;
layout(location = 0) flat out float tint_interstage_location0;
float textureLoad_c16e00() {
  uint v_1 = min(1u, (uint(textureSize(v_arg_0, 0).z) - 1u));
  uint v_2 = (v.metadata[(0u / 4u)][(0u % 4u)] - 1u);
  uint v_3 = min(uint(1), v_2);
  uvec2 v_4 = (uvec2(textureSize(v_arg_0, int(v_3)).xy) - uvec2(1u));
  ivec2 v_5 = ivec2(min(uvec2(ivec2(1)), v_4));
  ivec3 v_6 = ivec3(v_5, int(v_1));
  float res = texelFetch(v_arg_0, v_6, int(v_3)).x;
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput v_7 = VertexOutput(vec4(0.0f), 0.0f);
  v_7.pos = vec4(0.0f);
  v_7.prevent_dce = textureLoad_c16e00();
  return v_7;
}
void main() {
  VertexOutput v_8 = vertex_main_inner();
  gl_Position = vec4(v_8.pos.x, -(v_8.pos.y), ((2.0f * v_8.pos.z) - v_8.pos.w), v_8.pos.w);
  tint_interstage_location0 = v_8.prevent_dce;
  gl_PointSize = 1.0f;
}
