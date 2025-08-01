SKIP: INVALID

//
// fragment_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float tint_bitcast_from_f16(vector<float16_t, 2> src) {
  uint2 r = f32tof16(float2(src));
  return asfloat(((r.x & 65535u) | ((r.y & 65535u) << 16u)));
}

float bitcast_23c8bd() {
  vector<float16_t, 2> arg_0 = (float16_t(1.0h)).xx;
  float res = tint_bitcast_from_f16(arg_0);
  return res;
}

void fragment_main() {
  prevent_dce.Store(0u, asuint(bitcast_23c8bd()));
}

//
// compute_main
//

RWByteAddressBuffer prevent_dce : register(u0);
float tint_bitcast_from_f16(vector<float16_t, 2> src) {
  uint2 r = f32tof16(float2(src));
  return asfloat(((r.x & 65535u) | ((r.y & 65535u) << 16u)));
}

float bitcast_23c8bd() {
  vector<float16_t, 2> arg_0 = (float16_t(1.0h)).xx;
  float res = tint_bitcast_from_f16(arg_0);
  return res;
}

[numthreads(1, 1, 1)]
void compute_main() {
  prevent_dce.Store(0u, asuint(bitcast_23c8bd()));
}

//
// vertex_main
//
struct VertexOutput {
  float4 pos;
  float prevent_dce;
};

struct vertex_main_outputs {
  nointerpolation float VertexOutput_prevent_dce : TEXCOORD0;
  float4 VertexOutput_pos : SV_Position;
};


float tint_bitcast_from_f16(vector<float16_t, 2> src) {
  uint2 r = f32tof16(float2(src));
  return asfloat(((r.x & 65535u) | ((r.y & 65535u) << 16u)));
}

float bitcast_23c8bd() {
  vector<float16_t, 2> arg_0 = (float16_t(1.0h)).xx;
  float res = tint_bitcast_from_f16(arg_0);
  return res;
}

VertexOutput vertex_main_inner() {
  VertexOutput v = (VertexOutput)0;
  v.pos = (0.0f).xxxx;
  v.prevent_dce = bitcast_23c8bd();
  VertexOutput v_1 = v;
  return v_1;
}

vertex_main_outputs vertex_main() {
  VertexOutput v_2 = vertex_main_inner();
  vertex_main_outputs v_3 = {v_2.prevent_dce, v_2.pos};
  return v_3;
}

