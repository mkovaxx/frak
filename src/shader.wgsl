struct ViewUniform {
    center: vec2<f32>,
    extent: vec2<f32>,
};
@group(0) @binding(0)
var<uniform> view: ViewUniform;

struct VertexOutput {
    @builtin(position) clip_pos: vec4<f32>,
    @location(0) coord: vec2<f32>,
}

// Fragment shader

fn mul_complex(a: vec2<f32>, b: vec2<f32>) -> vec2<f32> {
    return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

fn div_complex(a: vec2<f32>, b: vec2<f32>) -> vec2<f32> {
    return vec2(a.x * b.x + a.y * b.y, a.y * b.x - a.x * b.y) / length(b);
}

fn eval(c: vec2<f32>, iter_max: u32) -> vec3<f32> {
    var z = c;
    var dz = vec2(1.0, 0.0);

    for (var i: u32 = 0u; i < iter_max; i++) {
        if dot(z, z) > 10000.0 {
            var u = normalize(div_complex(z, dz));
            return vec3(0.5 * u.x + 0.5, 0.5 * u.y + 0.5, 0.5);
        }
        dz = 2.0 * mul_complex(dz, z) + vec2(1.0, 0.0);
        z = mul_complex(z, z) + c;
    }

    return vec3(0.0, 0.0, 0.0);
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let c = eval(in.coord, 256u);
    return vec4<f32>(c.r, c.g, c.b, 1.0);
}

// Vertex shader

@vertex
fn vs_main(
    @builtin(vertex_index) in_vertex_index: u32,
) -> VertexOutput {
    var out: VertexOutput;
    let pos = vec2(
        2.0 * f32(i32(in_vertex_index & 1u)) - 1.0,
        2.0 * f32(i32(in_vertex_index >> 1u)) - 1.0,
    );
    out.clip_pos = vec4<f32>(pos.x, pos.y, 0.0, 1.0);
    out.coord = view.extent * pos + view.center;
    return out;
}
