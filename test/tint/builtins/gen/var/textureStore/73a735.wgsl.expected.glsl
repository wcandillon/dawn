#version 310 es
precision highp float;
precision highp int;

layout(rgba8i) uniform highp writeonly iimage2DArray arg_0;
void textureStore_73a735() {
  uvec2 arg_1 = uvec2(1u);
  int arg_2 = 1;
  ivec4 arg_3 = ivec4(1);
  imageStore(arg_0, ivec3(uvec3(arg_1, uint(arg_2))), arg_3);
}

void fragment_main() {
  textureStore_73a735();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba8i) uniform highp writeonly iimage2DArray arg_0;
void textureStore_73a735() {
  uvec2 arg_1 = uvec2(1u);
  int arg_2 = 1;
  ivec4 arg_3 = ivec4(1);
  imageStore(arg_0, ivec3(uvec3(arg_1, uint(arg_2))), arg_3);
}

void compute_main() {
  textureStore_73a735();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
