#version 310 es
precision highp float;
precision highp int;

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  uvec2 inner;
} prevent_dce;

layout(r32ui) uniform highp writeonly uimage2D arg_0;
uvec2 textureDimensions_dc83ce() {
  uvec2 res = uvec2(imageSize(arg_0));
  return res;
}

void fragment_main() {
  prevent_dce.inner = textureDimensions_dc83ce();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(binding = 0, std430) buffer prevent_dce_block_ssbo {
  uvec2 inner;
} prevent_dce;

layout(r32ui) uniform highp writeonly uimage2D arg_0;
uvec2 textureDimensions_dc83ce() {
  uvec2 res = uvec2(imageSize(arg_0));
  return res;
}

void compute_main() {
  prevent_dce.inner = textureDimensions_dc83ce();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
