#version 310 es
precision highp float;
precision highp int;

layout(rgba32f) uniform highp writeonly image3D arg_0;
void textureStore_7e787a() {
  imageStore(arg_0, ivec3(1), vec4(1.0f));
}

void fragment_main() {
  textureStore_7e787a();
}

void main() {
  fragment_main();
  return;
}
#version 310 es

layout(rgba32f) uniform highp writeonly image3D arg_0;
void textureStore_7e787a() {
  imageStore(arg_0, ivec3(1), vec4(1.0f));
}

void compute_main() {
  textureStore_7e787a();
}

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  compute_main();
  return;
}
