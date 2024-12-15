#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16, binding = 0, set = 0) uniform image2D screen_tex;

layout(push_constant, std430) uniform Params {
    vec2 screen_size;      // Screen resolution
    float curvature;       // Curvature control value
} p;

void main() {
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    vec2 size = p.screen_size;

    if (pixel.x >= size.x || pixel.y >= size.y) return;

    // Normalize pixel coordinates to UVs (range 0 to 1)
    vec2 uv = vec2(pixel) / size;

    // Convert UV range to -1 to 1
    uv = uv * 2.0 - 1.0;

    // Compute offset for spherical warping
    vec2 offset = uv / p.curvature;

    // Apply cubic spherical warping
    uv += uv * offset * offset;

    // Convert UV range back to 0 to 1
    uv = uv * 0.5 + 0.5;

    // Check if the warped UV is outside the valid range
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        imageStore(screen_tex, pixel, vec4(0.0, 0.0, 0.0, 1.0)); // Black for out-of-bounds UV
        return;
    }

    // Map warped UVs back to pixel coordinates
    ivec2 warped_pixel = ivec2(uv * size);

    // Fetch the color from the warped pixel coordinates
    vec4 color = imageLoad(screen_tex, warped_pixel);

    // Store the resulting color back to the texture
    imageStore(screen_tex, pixel, color);
}
