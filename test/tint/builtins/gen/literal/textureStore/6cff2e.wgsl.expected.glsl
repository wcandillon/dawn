#version 310 es
precision highp float;
precision highp int;

layout(r32ui) uniform highp writeonly uimage2D arg_0;
void textureStore_6cff2e() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void fragment_main() {
  textureStore_6cff2e();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(r32ui) uniform highp writeonly uimage2D arg_0;
void textureStore_6cff2e() {
  imageStore(arg_0, ivec2(1), uvec4(1u));
}

void compute_main() {
  textureStore_6cff2e();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
