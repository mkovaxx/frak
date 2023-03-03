struct VertexOutput {
    @builtin(position) clip_pos: vec4<f32>,
    @location(0) pos: vec2<f32>,
}

// Fragment shader

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = vec2<f32>(0.5 * in.pos.x + 0.5, 0.5 * in.pos.y + 0.5);
    return vec4<f32>(uv.x, uv.y, 0.0, 1.0);
}

// Vertex shader

@vertex
fn vs_main(
    @builtin(vertex_index) in_vertex_index: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let x = 2.0 * f32(i32(in_vertex_index & 1u)) - 1.0;
    let y = 2.0 * f32(i32(in_vertex_index >> 1u)) - 1.0;
    out.clip_pos = vec4<f32>(x, y, 0.0, 1.0);
    out.pos = out.clip_pos.xy;
    return out;
}
