shader_type canvas_item;

varying vec2 UV2;

void vertex() {
    UV2 = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy / 200.0;
}

void fragment() {
	COLOR.r+=COLOR.g*0.3*sin(4.0*UV2.x+2.*TIME);
	COLOR.g+=COLOR.g*0.3*sin(4.0*UV2.x+2.*TIME);
	COLOR.r+=COLOR.g*0.3*sin(4.0*UV2.y+2.*TIME);
	COLOR.g+=COLOR.g*0.3*sin(4.0*UV2.y+2.*TIME);
}
