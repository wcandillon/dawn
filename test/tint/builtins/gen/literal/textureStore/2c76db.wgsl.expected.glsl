#version 310 es
precision highp float;
precision highp int;

layout(rgba8_snorm) uniform highp writeonly image2D arg_0;
void textureStore_2c76db() {
  imageStore(arg_0, ivec2(uvec2(1u)), vec4(1.0f));
}

void fragment_main() {
  textureStore_2c76db();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba8_snorm) uniform highp writeonly image2D arg_0;
void textureStore_2c76db() {
  imageStore(arg_0, ivec2(uvec2(1u)), vec4(1.0f));
}

void compute_main() {
  textureStore_2c76db();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
