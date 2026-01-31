shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}
uniform float flash;
void fragment() {
	COLOR=mix(COLOR,vec4(1,1,1,COLOR.a),flash);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
