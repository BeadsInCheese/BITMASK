shader_type canvas_item;

varying vec2 UV2; // Use this as the UV for the effect

void vertex() {
    UV2 = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy;
    UV2 = abs(fract(UV2 * 0.5f) * 2.0f - 1.0f);
}

void fragment() {
	COLOR.r+=COLOR.g*0.4*sin(4.0*UV2.x+2.*TIME);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
