@group(0) @binding(0) var<storage, read_write> prevent_dce : vec4<f32>;

@group(1) @binding(0) var arg_0 : texture_storage_1d<r16snorm, read_write>;

fn textureLoad_159fb0() -> vec4<f32> {
  var res : vec4<f32> = textureLoad(arg_0, 1u);
  return res;
}

@fragment
fn fragment_main() {
  prevent_dce = textureLoad_159fb0();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureLoad_159fb0();
}
