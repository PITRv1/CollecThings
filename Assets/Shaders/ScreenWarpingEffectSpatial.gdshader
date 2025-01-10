shader_type spatial;
render_mode unshaded;

// Curvature control parameter
uniform float lens_curvature : hint_range(0.0, 2.0) = 0.096;

// Vignette strength control
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.895;

// Texture to be warped
uniform sampler2D texture_albedo : source_color;

void fragment() {
    // Normalized screen coordinates
    vec2 uv = UV;

    // Center the UV coordinates
    vec2 centered_uv = uv - 0.5;

    // Calculate lens distortion
    float lens_dist = length(centered_uv);
    float bend = lens_curvature * lens_dist * lens_dist;

    // Apply warped UV coordinates
    vec2 warped_uv = uv + centered_uv * bend;

    // Sample the texture with warped coordinates
    vec4 texture_color = texture(texture_albedo, warped_uv);

    // Vignette effect
    float vignette = 1.0 - dot(uv - 0.5, uv - 0.5) * 2.0 * vignette_strength;
    texture_color.rgb *= smoothstep(0.2, 0.8, vignette);

    // Clamp warped UVs to black at the edges
    if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0) {
        texture_color.rgb = vec3(0.0);
    }

    // Output final color
    ALBEDO = texture_color.rgb;
    ALPHA = texture_color.a;
}