shader_type canvas_item;

uniform int n : hint_range(2, 255);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// Sample the screen behind the ColorRect using SCREEN_TEXTURE
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	// If n is less than 2, output the sampled color directly
	if (n <= 1) {
		COLOR = color;
	} else {
		// Quantize the sampled color's RGB channels
		vec3 quantized_color = floor(color.rgb * float(n - 1) + 0.5) / float(n - 1);
		
		// Output the quantized color with the original alpha
		COLOR = vec4(quantized_color, color.a);
	}
}
