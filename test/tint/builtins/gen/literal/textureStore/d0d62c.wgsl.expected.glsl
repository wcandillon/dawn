#version 310 es
precision highp float;
precision highp int;

layout(rgba8ui) uniform highp writeonly uimage2D arg_0;
void textureStore_d0d62c() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void fragment_main() {
  textureStore_d0d62c();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba8ui) uniform highp writeonly uimage2D arg_0;
void textureStore_d0d62c() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void compute_main() {
  textureStore_d0d62c();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
