#version 310 es
precision highp float;
precision highp int;

layout(rgba16f) uniform highp writeonly image2D arg_0;
void textureStore_be6e30() {
  ivec2 arg_1 = ivec2(1);
  vec4 arg_2 = vec4(1.0f);
  imageStore(arg_0, arg_1, arg_2);
}

void fragment_main() {
  textureStore_be6e30();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba16f) uniform highp writeonly image2D arg_0;
void textureStore_be6e30() {
  ivec2 arg_1 = ivec2(1);
  vec4 arg_2 = vec4(1.0f);
  imageStore(arg_0, arg_1, arg_2);
}

void compute_main() {
  textureStore_be6e30();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
