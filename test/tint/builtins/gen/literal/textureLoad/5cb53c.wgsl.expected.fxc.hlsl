//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
Texture1D<int4> arg_0 : register(t0, space1);
int4 textureLoad_5cb53c() {
  int4 res = arg_0.Load(int2(int(1), int(0)));
  return res;
}

void fragment_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_5cb53c()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
Texture1D<int4> arg_0 : register(t0, space1);
int4 textureLoad_5cb53c() {
  int4 res = arg_0.Load(int2(int(1), int(0)));
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store4(0u, asuint(textureLoad_5cb53c()));
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  int4 prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation int4 VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


Texture1D<int4> arg_0 : register(t0, space1);
int4 textureLoad_5cb53c() {
  int4 res = arg_0.Load(int2(int(1), int(0)));
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput v = (VertexOutput)0;
  v.pos = (0.0f).xxxx;
  v.prevent_dce = textureLoad_5cb53c();
  VertexOutput v_1 = v;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

