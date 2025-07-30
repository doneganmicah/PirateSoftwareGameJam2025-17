shader_type canvas_item;

uniform vec4 loading_color    : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float progress = 0.0;

float shaped_lerp(float t, float t_start, float t_end, float min_out, float max_out, float power) {
    // Clamp t to [0.0, 1.0] range
    float normalized = clamp((t - t_start) / (t_end - t_start), 0.0, 1.0);

    // Triangle wave shape: 0.0 → 1.0 → 0.0 over [0.0, 1.0]
    float x = 1.0 - abs(2.0 * normalized - 1.0);

    // Apply exponential shaping (e.g., ease-in)
    float shaped = pow(x, power); // 0.5 is sqrt, adjust for curve intensity

    // Map to range [0.5, 1.0]
    return mix(min_out, max_out, shaped);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 bar_color;
	float wrapped_time = fract(TIME);
	
	if(UV.x <= progress) {
		bar_color = (loading_color * shaped_lerp(UV.y, 0.0, 1.0, 0.5, 1.0, 0.5));
		// Apply white pulse light based on time information
		if(UV.x >= wrapped_time - 0.25 && UV.x <= wrapped_time + 0.25)
		{
			bar_color = bar_color + shaped_lerp(UV.x, wrapped_time - 0.25, wrapped_time + 0.25, 0.0, 0.5, 2);
		}
		if(UV.x >= progress - 0.01)
		{
			bar_color = bar_color + shaped_lerp(UV.x,progress - 0.01, progress + 0.01, 0.0, 1.0, 2);
		}
	}
	else if(UV.x > progress)
	{
		bar_color = (background_color * shaped_lerp(UV.y, 0.0, 1.0, 0.5, 1.0, 0.5));
	}
	
	
	COLOR = bar_color;
}

