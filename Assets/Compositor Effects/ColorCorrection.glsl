#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16, binding = 0, set = 0) uniform image2D screen_tex;

layout(push_constant, std430) uniform Params {
    vec2 screen_size;
    float contrast;      // Controls contrast
    float brightness;    // Controls brightness
    float saturation;    // Controls saturation
    float gamma;         // Controls gamma
} p;

// Helper function to adjust saturation
vec3 adjust_saturation(vec3 color, float saturation) {
    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722)); // Luminance
    return mix(vec3(gray), color, saturation);
}

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 size = p.screen_size;

    if (pixel.x >= size.x || pixel.y >= size.y) return;

    // Load the pixel color
    vec4 color = imageLoad(screen_tex, pixel);

    // Apply brightness adjustment
    vec3 corrected = color.rgb + p.brightness;

    // Apply contrast adjustment
    corrected = ((corrected - 0.5) * p.contrast) + 0.5;

    // Apply saturation adjustment
    corrected = adjust_saturation(corrected, p.saturation);

    // Apply gamma correction
    corrected = pow(corrected, vec3(1.0 / p.gamma));

    // Clamp the result to valid color range
    corrected = clamp(corrected, 0.0, 1.0);

    // Store the corrected color back to the texture
    imageStore(screen_tex, pixel, vec4(corrected, color.a));
}
