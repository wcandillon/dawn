SKIP: INVALID

//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int transpose_7be8b2() {
  matrix<float16_t, 2, 2> res = matrix<float16_t, 2, 2>((float16_t(1.0h)).xx, (float16_t(1.0h)).xx);
  return (((res[0u].x == float16_t(0.0h))) ? (int(1)) : (int(0)));
}

void fragment_main() {
  prevent_dce.Store(0u, asuint(transpose_7be8b2()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
int transpose_7be8b2() {
  matrix<float16_t, 2, 2> res = matrix<float16_t, 2, 2>((float16_t(1.0h)).xx, (float16_t(1.0h)).xx);
  return (((res[0u].x == float16_t(0.0h))) ? (int(1)) : (int(0)));
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store(0u, asuint(transpose_7be8b2()));
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  int prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation int VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


int transpose_7be8b2() {
  matrix<float16_t, 2, 2> res = matrix<float16_t, 2, 2>((float16_t(1.0h)).xx, (float16_t(1.0h)).xx);
  return (((res[0u].x == float16_t(0.0h))) ? (int(1)) : (int(0)));
}

VertexOutput vertex_main_inner() {
  VertexOutput v = (VertexOutput)0;
  v.pos = (0.0f).xxxx;
  v.prevent_dce = transpose_7be8b2();
  VertexOutput v_1 = v;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

