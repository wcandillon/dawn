SKIP: FAILED

float3 fwidth_5d1b39() {
  float3 arg_0 = (1.0f).xxx;
  float3 res = fwidth(arg_0);
  return res;
}

void fragment_main() {
  prevent_dce = fwidth_5d1b39();
}

DXC validation failure:
hlsl.hlsl:8:3: error: use of undeclared identifier 'prevent_dce'
  prevent_dce = fwidth_5d1b39();
  ^

