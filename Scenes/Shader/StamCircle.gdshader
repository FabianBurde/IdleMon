shader_type canvas_item;

void vertex() {

	// Called for every vertex the material is visible on.
}

void fragment() {
	float inner_circle = distance(vec2(0.5),UV);
	float outer_circle = distance(vec2(0.5),UV);
	float circ1 = step(outer_circle,0.4);
	float circ2 = step(inner_circle,0.33);
	COLOR.a = circ1-circ2;
	COLOR.rgb = vec3(0.0,1.0,0.0);
	
	float progress = 0.0;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
