shader_type spatial;
render_mode cull_disabled, unshaded, shadows_disabled;

uniform vec4 color : source_color;

void fragment() {
	ALBEDO.rgb = color.rgb;
	ALPHA = color.a;
}
