SKIP: FAILED

void bar() {
}

float4 main() {
  float2 a = (0.0f).xx;
  bar();
  return float4(0.40000000596046447754f, 0.40000000596046447754f, 0.80000001192092895508f, 1.0f);
}

DXC validation failure:
hlsl.hlsl:4:1: error: Semantic must be defined for all outputs of an entry function or patch constant function
float4 main() {
^

