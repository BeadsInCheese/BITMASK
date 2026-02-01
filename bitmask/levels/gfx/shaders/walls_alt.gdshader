shader_type canvas_item;

varying vec2 UV2; // Use this as the UV for the effect

void vertex() {
    UV2 = (MODEL_MATRIX * vec4(VERTEX, 0, 1)).xy / 200.0;
}

uniform sampler2D noise;
uniform float cycle_speed;
uniform float scroll_speed;
uniform float scale;

uniform float red;
uniform float green;
uniform float blue;

void fragment() {
	COLOR*=vec4(red, green, blue, 1)*0.8+texture(noise,fract((UV2.xy+200.)*scale+-2.*scroll_speed*TIME)).r*texture(noise,fract(UV2.xy*scale+scroll_speed*TIME)).r;
}
