shader_type spatial;

uniform sampler2D texture_albedo : hint_depth_texture, filter_linear_mipmap; // Explicitly define texture sampler
uniform float frequency : hint_range(1.0, 2000.0) = 10.0; // Frequency of the sine wave
uniform float line_brightness : hint_range(0.0, 1.0) = 0.5; // Brightness of the lines

void fragment() {
    vec2 uv = UV; // Screen UV coordinates (range 0-1)
    
    // Sine wave modulation for scan lines
    float sine_wave = (sin(uv.y * frequency) + 1.0) * 0.5; // Range [0, 1]
    sine_wave = mix(1.0, sine_wave, line_brightness);      // Apply brightness control

    // Simulate artifacting effects with sine and cosine functions
    float green_mod = (sin(uv.y * frequency) + 1.0) * 0.15 + 1.0; // Range [1.0, 1.3]
    float rb_mod = (cos(uv.y * frequency) + 1.0) * 0.10 + 1.0;   // Range [1.0, 1.2]

    // Sample the texture using UV coordinates
    vec4 color = texture(texture_albedo, UV);

    // Apply artifacting
    color.g *= green_mod; // Modify green channel
    color.r *= rb_mod;    // Modify red channel
    color.b *= rb_mod;    // Modify blue channel

    // Apply scan line effect
    color.rgb *= sine_wave;

    // Output final color
    ALBEDO = color.rgb;
    ALPHA = color.a;
}
