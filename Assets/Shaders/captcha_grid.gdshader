shader_type canvas_item;

uniform float border_width = 1.0;
uniform vec4 border_color : source_color = vec4(0.7, 0.7, 0.7, 1.7);
uniform bool selected = false;
uniform float dim_factor = 0.4; // 0 = black, 1 = no dimming

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 uv_pixel = UV * tex_size;

    bool is_border =
        uv_pixel.x < border_width ||
        uv_pixel.x > tex_size.x - border_width ||
        uv_pixel.y < border_width ||
        uv_pixel.y > tex_size.y - border_width;

    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a == 0.0) {
        discard;
    }

    if (is_border) {
        COLOR = border_color;
    } else {
        COLOR = tex_color;

        // Dim the tile if selected
        if (selected) {
            COLOR.rgb *= dim_factor;
        }
    }
}

