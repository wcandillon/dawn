//
// fragment_main
//
#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430)
buffer f_prevent_dce_block_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, std140)
uniform f_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp usampler2DArray f_arg_0;
uvec4 textureLoad_8527b1() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  uvec2 v_2 = arg_1;
  uint v_3 = arg_2;
  uint v_4 = arg_3;
  uint v_5 = min(v_3, (uint(textureSize(f_arg_0, 0).z) - 1u));
  uint v_6 = min(v_4, (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u));
  ivec2 v_7 = ivec2(min(v_2, (uvec2(textureSize(f_arg_0, int(v_6)).xy) - uvec2(1u))));
  ivec3 v_8 = ivec3(v_7, int(v_5));
  uvec4 res = texelFetch(f_arg_0, v_8, int(v_6));
  return res;
}
void main() {
  v.inner = textureLoad_8527b1();
}
//
// compute_main
//
#version 310 es

layout(binding = 0, std430)
buffer prevent_dce_block_1_ssbo {
  uvec4 inner;
} v;
layout(binding = 0, std140)
uniform TintTextureUniformData_1_ubo {
  uvec4 metadata[1];
} v_1;
uniform highp usampler2DArray arg_0;
uvec4 textureLoad_8527b1() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  uvec2 v_2 = arg_1;
  uint v_3 = arg_2;
  uint v_4 = arg_3;
  uint v_5 = min(v_3, (uint(textureSize(arg_0, 0).z) - 1u));
  uint v_6 = min(v_4, (v_1.metadata[(0u / 4u)][(0u % 4u)] - 1u));
  ivec2 v_7 = ivec2(min(v_2, (uvec2(textureSize(arg_0, int(v_6)).xy) - uvec2(1u))));
  ivec3 v_8 = ivec3(v_7, int(v_5));
  uvec4 res = texelFetch(arg_0, v_8, int(v_6));
  return res;
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  v.inner = textureLoad_8527b1();
}
//
// vertex_main
//
#version 310 es


struct VertexOutput {
  vec4 pos;
  uvec4 prevent_dce;
};

layout(binding = 0, std140)
uniform v_TintTextureUniformData_ubo {
  uvec4 metadata[1];
} v;
uniform highp usampler2DArray v_arg_0;
layout(location = 0) flat out uvec4 tint_interstage_location0;
uvec4 textureLoad_8527b1() {
  uvec2 arg_1 = uvec2(1u);
  uint arg_2 = 1u;
  uint arg_3 = 1u;
  uvec2 v_1 = arg_1;
  uint v_2 = arg_2;
  uint v_3 = arg_3;
  uint v_4 = min(v_2, (uint(textureSize(v_arg_0, 0).z) - 1u));
  uint v_5 = min(v_3, (v.metadata[(0u / 4u)][(0u % 4u)] - 1u));
  ivec2 v_6 = ivec2(min(v_1, (uvec2(textureSize(v_arg_0, int(v_5)).xy) - uvec2(1u))));
  ivec3 v_7 = ivec3(v_6, int(v_4));
  uvec4 res = texelFetch(v_arg_0, v_7, int(v_5));
  return res;
}
VertexOutput vertex_main_inner() {
  VertexOutput v_8 = VertexOutput(vec4(0.0f), uvec4(0u));
  v_8.pos = vec4(0.0f);
  v_8.prevent_dce = textureLoad_8527b1();
  return v_8;
}
void main() {
  VertexOutput v_9 = vertex_main_inner();
  gl_Position = vec4(v_9.pos.x, -(v_9.pos.y), ((2.0f * v_9.pos.z) - v_9.pos.w), v_9.pos.w);
  tint_interstage_location0 = v_9.prevent_dce;
  gl_PointSize = 1.0f;
}
