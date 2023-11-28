shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform vec4 color : source_color;
uniform sampler2D albedo; 

void fragment() {
	vec4 textureColor = texture(albedo, UV * 10.0);
	ALBEDO.rgb = color.rgb * textureColor.rgb;
	ALPHA = color.a;
}
