#version 310 es
precision highp float;
precision highp int;

layout(rgba16ui) uniform highp writeonly uimage2D arg_0;
void textureStore_03e7a0() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void fragment_main() {
  textureStore_03e7a0();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba16ui) uniform highp writeonly uimage2D arg_0;
void textureStore_03e7a0() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void compute_main() {
  textureStore_03e7a0();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
