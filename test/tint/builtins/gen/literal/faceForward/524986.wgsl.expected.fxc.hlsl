SKIP: INVALID

//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 3> faceForward_524986() {
  vector<float16_t, 3> res = (float16_t(-1.0h)).xxx;
  return res;
}

void fragment_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, faceForward_524986());
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
vector<float16_t, 3> faceForward_524986() {
  vector<float16_t, 3> res = (float16_t(-1.0h)).xxx;
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store<vector<float16_t, 3> >(0u, faceForward_524986());
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  vector<float16_t, 3> prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation vector<float16_t, 3> VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


vector<float16_t, 3> faceForward_524986() {
  vector<float16_t, 3> res = (float16_t(-1.0h)).xxx;
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput v = (VertexOutput)0;
  v.pos = (0.0f).xxxx;
  v.prevent_dce = faceForward_524986();
  VertexOutput v_1 = v;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

