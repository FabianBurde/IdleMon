extends Label

@export var dmg_num: int = 5
@export var float_speed: float = 50.0
@export var fade_speed: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(dmg_num)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= float_speed * delta
	modulate.a -= fade_speed * delta
	if modulate.a <= 0:
		queue_free()
