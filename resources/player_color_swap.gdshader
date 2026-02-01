shader_type spatial;
render_mode depth_prepass_alpha;

uniform sampler2D base_texture;
uniform vec3 color_focus : source_color;

vec3 rgb_to_hsv(vec3 input) {
	float cmax, cmin, delta;
	cmax = max(input.r, max(input.g, input.b));
	cmin = min(input.r, min(input.g, input.b));
	delta = cmax - cmin;
	
	float h;
	if (cmax == input.r) {
		h = 60.0 * mod((input.g - input.b) / delta, 6);
	}
	else if (cmax == input.g) {
		h = 60.0 * ((input.b - input.r) / delta + 2.0); 
	}
	else if (cmax == input.b) {
		h = 60.0 * ((input.r - input.g) / delta + 4.0);
	}
	
	float s = 0.0;
	if (cmax > 0.0001) {
		s = delta / cmax;
	}
	
	return vec3(h, s, cmax);
}

void fragment() {
	vec3 base_value = texture(base_texture, UV).xyz;
	vec3 base_value_hsv = rgb_to_hsv(base_value);
	vec3 color_focus_hsv = rgb_to_hsv(color_focus);
	
	if (color_focus == vec3(1.0)) {
		ALBEDO = base_value;
	}
	else if (color_focus == vec3(0.0)) {
		ALBEDO = base_value;
		ALPHA = 0.35;
	}
	else {
		vec3 greyscale_rgb = vec3((base_value.r + base_value.g + base_value.b) / 3.0);
		float dist = abs(base_value_hsv.x - color_focus_hsv.x);
		if (dist > 180.0) {
			dist = 360.0 - dist;
		}
		
		ALBEDO = mix(base_value, greyscale_rgb, clamp((dist / 30.0), 0.0, 1.0));
	}
}
