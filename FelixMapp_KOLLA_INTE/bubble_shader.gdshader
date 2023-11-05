shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform vec3 billboard;
uniform vec3 tint : source_color;
uniform sampler2D albedo;

void vertex() {
	mat4 scale_matrix = mat4(
		vec4(MODEL_MATRIX[0].x, 0, 0, 0),
		vec4(0, MODEL_MATRIX[1].y, 0, 0),
		vec4(0, 0, MODEL_MATRIX[2].z, 0),
		vec4(0, 0, 0, 1)
	);
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view * scale_matrix;	
}

void fragment() {
	vec4 color = texture(albedo, UV);
	ALBEDO.rgb = color.rgb * tint;
	ALPHA = color.a;
}
