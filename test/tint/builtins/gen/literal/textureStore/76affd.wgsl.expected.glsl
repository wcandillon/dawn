#version 310 es
precision highp float;
precision highp int;

layout(rgba8) uniform highp writeonly image2DArray arg_0;
void textureStore_76affd() {
  imageStore(arg_0, ivec3(ivec2(1), int(1u)), vec4(1.0f));
}

void fragment_main() {
  textureStore_76affd();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba8) uniform highp writeonly image2DArray arg_0;
void textureStore_76affd() {
  imageStore(arg_0, ivec3(ivec2(1), int(1u)), vec4(1.0f));
}

void compute_main() {
  textureStore_76affd();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
