shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 1.0; // Vignette intensity
uniform vec3 vignette_color : source_color = vec3(0.0, 0.0, 0.0); // Vignette color

void fragment() {
    // Calculate normalized UV coordinates
    vec2 uv = UV;

    // Distance from the center of the screen
    vec2 center = vec2(0.5, 0.5); // Center of the screen
    float dist = distance(uv, center);

    // Vignette effect using smoothstep for a smooth gradient
    float vignette = smoothstep(0.5, 0.8, dist);

    // Apply intensity and vignette color
    vec3 color = vignette_color * vignette * intensity;

    // Output the final color with alpha
    COLOR = vec4(color, vignette * intensity * 2.0);
}
