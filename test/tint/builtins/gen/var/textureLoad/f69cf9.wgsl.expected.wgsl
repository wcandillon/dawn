requires texel_buffers;

@group(0) @binding(0) var<storage, read_write> prevent_dce : vec4<u32>;

@group(1) @binding(0) var arg_0 : texel_buffer<r32uint, read>;

fn textureLoad_f69cf9() -> vec4<u32> {
  var arg_1 = 1i;
  var res : vec4<u32> = textureLoad(arg_0, arg_1);
  return res;
}

@fragment
fn fragment_main() {
  prevent_dce = textureLoad_f69cf9();
}

@compute @workgroup_size(1)
fn compute_main() {
  prevent_dce = textureLoad_f69cf9();
}

struct VertexOutput {
  @builtin(position)
  pos : vec4<f32>,
  @location(0) @interpolate(flat)
  prevent_dce : vec4<u32>,
}

@vertex
fn vertex_main() -> VertexOutput {
  var out : VertexOutput;
  out.pos = vec4<f32>();
  out.prevent_dce = textureLoad_f69cf9();
  return out;
}
