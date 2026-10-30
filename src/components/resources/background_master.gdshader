shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.2, 0.2);

void fragment() {
	vec2 shifted_uv = UV + (scroll_speed * TIME);
	COLOR = texture(TEXTURE,shifted_uv);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
