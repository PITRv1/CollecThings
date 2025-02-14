shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;
uniform float line_amount : hint_range(1.0, 2000.0) = 256.918; // Frequency of scan lines
uniform float time_scale : hint_range(0.0, 10.0) = 0.05; // Speed of scan line motion
uniform float line_brightness : hint_range(0.0, 1.0) = 0.728; // Brightness of the scan lines
uniform float line_opacity : hint_range(0.0, 1.0) = 0.457; // Opacity of the scan lines
uniform float emission_power : hint_range(0.0, 1.0) = 0.182;
uniform vec3 line_color : source_color = vec3(1.0, 1.0, 1.0); // Color of the scan lines (default is white)
void fragment() {
    vec2 uv = UV; // Object's UV coordinates
    // Add time-based scrolling effect to sine wave
    float time_offset = mod(TIME * time_scale, 1.0); // Repeat effect over time
    float sine_wave = (sin((uv.y + time_offset) * line_amount) + 1.0) * 0.5; // Range [0, 1]
    sine_wave = mix(1.0, sine_wave, line_brightness); // Apply brightness control
    // Simulate artifacting effects with sine and cosine functions
    float green_mod = (sin((uv.y + time_offset) * line_amount) + 1.0) * 0.15 + 1.0; // Range [1.0, 1.3]
    float rb_mod = (cos((uv.y + time_offset) * line_amount) + 1.0) * 0.10 + 1.0;   // Range [1.0, 1.2]
    // Apply artifacting effects to the color channels
    vec3 artifacted_color = vec3(rb_mod, green_mod, rb_mod);
    // Blend artifacted color with user-defined line color
    vec3 final_color = artifacted_color * line_color;
    // Make pixels outside the scan line fully transparent
    if (sine_wave < 0.1) { // Threshold for non-line pixels
        ALBEDO = vec3(0.0); // Transparent pixel
        ALPHA = 0.0;
    } else {
        // Apply scan line modulation to valid pixels
        final_color *= sine_wave; // Modulate color with sine wave
        ALBEDO = final_color; // Final color of the line
        ALPHA = sine_wave * line_opacity; // Transparency controlled by sine wave and line_opacity
        EMISSION = ALBEDO * emission_power;
    }
}