#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  uvec4 inner;
} prevent_dce;

layout(r32ui) uniform highp uimage3D arg_0;
uvec4 textureLoad_1b4332() {
  uvec4 res = imageLoad(arg_0, ivec3(1));
  return res;
}

void fragment_main() {
  prevent_dce.inner = textureLoad_1b4332();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  uvec4 inner;
} prevent_dce;

layout(r32ui) uniform highp uimage3D arg_0;
uvec4 textureLoad_1b4332() {
  uvec4 res = imageLoad(arg_0, ivec3(1));
  return res;
}

void compute_main() {
  prevent_dce.inner = textureLoad_1b4332();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
