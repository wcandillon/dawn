requires texel_buffers;

@group(0) @binding(0) var<storage, read_write> prevent_dce : vec4<f32>;

@group(1) @binding(0) var arg_0 : texel_buffer<r16snorm, read_write>;

fn textureLoad_b56c96() -> vec4<f32> {
  var res : vec4<f32> = textureLoad(arg_0, 1u);
  return res;
}

@fragment
fn fragment_main() {
  prevent_dce = textureLoad_b56c96();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureLoad_b56c96();
}
