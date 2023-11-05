shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform sampler2D albedo;

void fragment() {
	ALBEDO.rgb = texture(albedo, UV).rgb;
}
