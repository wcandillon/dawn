#version 310 es
precision highp float;
precision highp int;

layout(rgba32f) uniform highp writeonly image2DArray arg_0;
void textureStore_06e49c() {
  imageStore(arg_0, ivec3(ivec2(1), int(1u)), vec4(1.0f));
}

void fragment_main() {
  textureStore_06e49c();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba32f) uniform highp writeonly image2DArray arg_0;
void textureStore_06e49c() {
  imageStore(arg_0, ivec3(ivec2(1), int(1u)), vec4(1.0f));
}

void compute_main() {
  textureStore_06e49c();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
