#version 310 es
precision highp float;
precision highp int;

layout(rgba16f) uniform highp writeonly image2DArray arg_0;
void textureStore_a0f96e() {
  imageStore(arg_0, ivec3(uvec3(uvec2(1u), 1u)), vec4(1.0f));
}

void fragment_main() {
  textureStore_a0f96e();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba16f) uniform highp writeonly image2DArray arg_0;
void textureStore_a0f96e() {
  imageStore(arg_0, ivec3(uvec3(uvec2(1u), 1u)), vec4(1.0f));
}

void compute_main() {
  textureStore_a0f96e();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
