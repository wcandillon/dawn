#version 310 es
precision highp float;
precision highp int;

layout(rgba16i) uniform highp writeonly iimage2D arg_0;
void textureStore_9e3ec5() {
  ivec2 arg_1 = ivec2(1);
  ivec4 arg_2 = ivec4(1);
  imageStore(arg_0, arg_1, arg_2);
}

void fragment_main() {
  textureStore_9e3ec5();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba16i) uniform highp writeonly iimage2D arg_0;
void textureStore_9e3ec5() {
  ivec2 arg_1 = ivec2(1);
  ivec4 arg_2 = ivec4(1);
  imageStore(arg_0, arg_1, arg_2);
}

void compute_main() {
  textureStore_9e3ec5();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
