#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16, binding = 0, set = 0) uniform image2D screen_tex;

layout(push_constant, std430) uniform Params {
    vec2 screen_size;
    float dithering_intensity; // Controls the visibility of the dithering effect
} p;

// 4x4 Bayer threshold matrix normalized to [0.0, 1.0]
const float bayer_matrix[16] = float[16](
    0.0 / 16.0,  8.0 / 16.0,  2.0 / 16.0, 10.0 / 16.0,
   12.0 / 16.0,  4.0 / 16.0, 14.0 / 16.0,  6.0 / 16.0,
    3.0 / 16.0, 11.0 / 16.0,  1.0 / 16.0,  9.0 / 16.0,
   15.0 / 16.0,  7.0 / 16.0, 13.0 / 16.0,  5.0 / 16.0
);

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 size = p.screen_size;

    if (pixel.x >= size.x || pixel.y >= size.y) return;

    // Load the pixel color
    vec4 color = imageLoad(screen_tex, pixel);

    // Get the Bayer threshold value
    int x_mod = pixel.x % 4;
    int y_mod = pixel.y % 4;
    float threshold = bayer_matrix[y_mod * 4 + x_mod];

    // Apply Bayer dithering to each color channel
    vec4 dithered_color = vec4(
        color.r > threshold ? 1.0 : 0.0,
        color.g > threshold ? 1.0 : 0.0,
        color.b > threshold ? 1.0 : 0.0,
        color.a
    );

    // Blend the original color with the dithered color based on dithering intensity
    vec4 output_color = mix(color, dithered_color, p.dithering_intensity);

    // Store the resulting color back to the texture
    imageStore(screen_tex, pixel, output_color);
}
