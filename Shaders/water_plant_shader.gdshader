shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled;

uniform sampler2D albedo;
uniform float swaySpeed = 0.3;
uniform float swayFactor = 1.0;
uniform float swayOffset = 1.0;

void fragment() {
	vec4 color = texture(albedo, UV);
	ALBEDO.rgb = color.rgb;
	ALPHA = color.a;
}

float square(float a) {
	return a * a;
}

void vertex() {
	float skew = VERTEX.z - 0.5;
	float impactFactor = square(VERTEX.z - 0.5) * skew;
	
	VERTEX.x += impactFactor * sin(TIME * swaySpeed + swayOffset) * swayFactor;
}