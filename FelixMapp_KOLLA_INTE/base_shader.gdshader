shader_type spatial;
render_mode unshaded, shadows_disabled, depth_draw_always;

uniform sampler2D albedo;

void fragment() {
	vec4 color = texture(albedo, UV);
	ALBEDO.rgb = color.rgb;
	ALPHA = color.a;
}
