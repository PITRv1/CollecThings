#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16, binding = 0, set = 0) uniform image2D screen_tex;

layout(push_constant, std430) uniform Params {
    vec2 screen_size;      // Screen resolution
    float frequency;       // Frequency of the sine wave
    float line_brightness; // Brightness of the lines (0 = dark, 1 = light)
} p;

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 size = p.screen_size;

    if (pixel.x >= size.x || pixel.y >= size.y) return;

    // Normalize pixel coordinates to UVs (range 0 to 1)
    vec2 uv = vec2(pixel) / size;

    // Sine wave modulation for scan lines
    float sine_wave = (sin(uv.y * p.frequency * size.y) + 1.0) * 0.5; // Range [0, 1]
    sine_wave = mix(1.0, sine_wave, p.line_brightness);              // Apply brightness control

    // Simulate artifacting effects with sine and cosine functions
    float green_mod = (sin(uv.y * p.frequency * size.y) + 1.0) * 0.15 + 1.0; // Range [1.0, 1.3]
    float rb_mod = (cos(uv.y * p.frequency * size.y) + 1.0) * 0.10 + 1.0;   // Range [1.0, 1.2]

    // Load the original color from the screen texture
    vec4 color = imageLoad(screen_tex, pixel);

    // Apply artifacting
    color.g *= green_mod; // Modify green channel
    color.r *= rb_mod;    // Modify red channel
    color.b *= rb_mod;    // Modify blue channel

    // Apply scan line effect
    color.rgb *= sine_wave;

    // Store the resulting color back to the texture
    imageStore(screen_tex, pixel, color);
}
