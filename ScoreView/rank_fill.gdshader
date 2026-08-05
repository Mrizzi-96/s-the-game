shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform bool use_fill = true;
uniform vec4 fill_color : source_color = vec4(0.262745, 0.039216, 0.015686, 1.0);
uniform vec4 base_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// contorno: cerca un pixel opaco entro outline_width, campionando in cerchio
	float outline_alpha = 0.0;
	vec2 px = outline_width * TEXTURE_PIXEL_SIZE;
	for (int i = 0; i < 16; i++) {
		float angle = float(i) / 16.0 * TAU;
		vec2 offset = vec2(cos(angle), sin(angle)) * px;
		outline_alpha = max(outline_alpha, texture(TEXTURE, UV + offset).a);
	}

	// riempimento dal basso verso l'alto
	float fill_line = 1.0 - progress;
	float edge = smoothstep(fill_line - 0.01, fill_line + 0.01, UV.y);
	vec3 fill_tint = mix(base_color.rgb, fill_color.rgb, edge);
	vec3 inside_tint = mix(tex_color.rgb, fill_tint, float(use_fill));

	// niente "if": mescola contorno (fuori) e tint (dentro) in base all'alpha della texture
	float is_inside = step(0.5, tex_color.a);
	vec3 final_rgb = mix(outline_color.rgb, inside_tint, is_inside);
	float final_alpha = mix(outline_alpha, tex_color.a, is_inside);

	COLOR = vec4(final_rgb, final_alpha);
}
