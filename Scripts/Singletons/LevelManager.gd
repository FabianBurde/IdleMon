extends Node

var level_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_data("res://Data/levelData.json")
	print(level_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_level_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		level_data = JSON.parse_string(file.get_as_text())
		file.close()