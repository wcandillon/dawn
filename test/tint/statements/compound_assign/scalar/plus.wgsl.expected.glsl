#version 310 es


struct S {
  int a;
};

layout(binding = 0, std430)
buffer v_block_1_ssbo {
  S inner;
} v_1;
void foo() {
  uint v_2 = uint(v_1.inner.a);
  v_1.inner.a = int((v_2 + uint(2)));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
}
