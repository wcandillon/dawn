#version 310 es
precision highp float;
precision highp int;

layout(rgba16ui) uniform highp writeonly uimage3D arg_0;
void textureStore_068641() {
  ivec3 arg_1 = ivec3(1);
  uvec4 arg_2 = uvec4(1u);
  imageStore(arg_0, arg_1, arg_2);
}

void fragment_main() {
  textureStore_068641();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba16ui) uniform highp writeonly uimage3D arg_0;
void textureStore_068641() {
  ivec3 arg_1 = ivec3(1);
  uvec4 arg_2 = uvec4(1u);
  imageStore(arg_0, arg_1, arg_2);
}

void compute_main() {
  textureStore_068641();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
