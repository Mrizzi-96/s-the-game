shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 fill_color : source_color = vec4(0.262745, 0.039216, 0.015686, 1.0);
uniform vec4 base_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float fill_line = 1.0 - progress;
	float edge = smoothstep(fill_line - 0.01, fill_line + 0.01, UV.y);
	vec3 tint = mix(base_color.rgb, fill_color.rgb, edge);
	COLOR = vec4(tint, tex_color.a);
}
