shader_type canvas_item;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
void fragment() {
    vec2 uv = UV - 0.5;
    float vignette = dot(uv, uv);
    COLOR = vec4(0.0, 0.0, 0.0, vignette * intensity * 2.0);
}