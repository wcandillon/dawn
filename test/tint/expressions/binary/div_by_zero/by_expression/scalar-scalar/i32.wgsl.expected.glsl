#version 310 es

int tint_div_i32(int lhs, int rhs) {
  uint v = uint((lhs == (-2147483647 - 1)));
  bool v_1 = bool((v & uint((rhs == -1))));
  uint v_2 = uint((rhs == 0));
  return (lhs / mix(rhs, 1, bool((v_2 | uint(v_1)))));
}
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
void main() {
  int a = 1;
  int b = 0;
  int v_3 = a;
  int v_4 = b;
  uint v_5 = uint(b);
  int r = tint_div_i32(v_3, int((v_5 + uint(v_4))));
}
