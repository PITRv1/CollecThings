#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) readonly buffer Params {
    vec2 raster_size;
    vec2 reserved;
} params;

layout(rgba16f, set = 0, binding = 1) uniform image2D color_image;

void main() {
    vec2 size = params.raster_size;
    ivec2 uv = ivec2(gl_GlobalInvocationID.xy);

    // Check if within bounds
    if (uv.x >= size.x || uv.y >= size.y) {
        return;
    }

    // Load the pixel color from the input image
    vec4 color = imageLoad(color_image, uv);

    // Pass the color back unchanged
    imageStore(color_image, uv, color);
}
