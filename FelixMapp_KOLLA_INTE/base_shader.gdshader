shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform sampler2D albedo;

void fragment() {
	vec4 color = texture(albedo, UV);
	ALBEDO.rgb = color.rgb;
	ALPHA = color.a;
}
