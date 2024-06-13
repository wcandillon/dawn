#version 310 es
precision highp float;
precision highp int;

layout(r32i) uniform highp iimage2D arg_0;
void textureStore_f64d69() {
  int arg_1 = 1;
  ivec4 arg_2 = ivec4(1);
  imageStore(arg_0, ivec2(arg_1, 0), arg_2);
}

void fragment_main() {
  textureStore_f64d69();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(r32i) uniform highp iimage2D arg_0;
void textureStore_f64d69() {
  int arg_1 = 1;
  ivec4 arg_2 = ivec4(1);
  imageStore(arg_0, ivec2(arg_1, 0), arg_2);
}

void compute_main() {
  textureStore_f64d69();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
