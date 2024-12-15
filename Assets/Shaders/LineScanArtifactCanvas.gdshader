shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE; // Explicit texture sampler
uniform float frequency : hint_range(1.0, 2000.0) = 422.915; // Frequency of the sine wave
uniform float line_brightness : hint_range(0.0, 1.0) = 0.077; // Brightness of the lines
uniform float time_scale : hint_range(0.0, 1.0) = 0.054; // Speed of the scan line motion

void fragment() {
    vec2 uv = SCREEN_UV; // Use screen UV coordinates

    // Add time-based scrolling effect to sine wave
    float time_offset = mod(TIME * time_scale, 1.0); // Repeat effect over time
    float sine_wave = (sin((uv.y + time_offset) * frequency) + 1.0) * 0.5; // Range [0, 1]
    sine_wave = mix(1.0, sine_wave, line_brightness);// Apply brightness control

    // Simulate artifacting effects with sine and cosine functions
    float green_mod = (sin((uv.y + time_offset) * frequency) + 1.0) * 0.15 + 1.0; // Range [1.0, 1.3]
    float rb_mod = (cos((uv.y + time_offset) * frequency) + 1.0) * 0.10 + 1.0;// Range [1.0, 1.2]

    // Sample the texture below the canvas item
    vec4 color = texture(TEXTURE, uv);

    // Apply artifacting
    color.g *= green_mod; // Modify green channel
    color.r *= rb_mod;// Modify red channel
    color.b *= rb_mod;// Modify blue channel

    // Apply scan line effect
    color.rgb *= sine_wave;

    // Output final color
    COLOR = color;
}