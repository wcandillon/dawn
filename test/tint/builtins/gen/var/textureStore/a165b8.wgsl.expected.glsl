#version 310 es
precision highp float;
precision highp int;

layout(rgba8) uniform highp writeonly image2D arg_0;
void textureStore_a165b8() {
  uvec2 arg_1 = uvec2(1u);
  vec4 arg_2 = vec4(1.0f);
  imageStore(arg_0, ivec2(arg_1), arg_2.bgra);
}

void fragment_main() {
  textureStore_a165b8();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba8) uniform highp writeonly image2D arg_0;
void textureStore_a165b8() {
  uvec2 arg_1 = uvec2(1u);
  vec4 arg_2 = vec4(1.0f);
  imageStore(arg_0, ivec2(arg_1), arg_2.bgra);
}

void compute_main() {
  textureStore_a165b8();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
