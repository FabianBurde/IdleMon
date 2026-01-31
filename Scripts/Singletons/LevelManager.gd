extends Node

var level_data = {}
var current_level: int = 1
var enemies_killed: int = 0
var active_enemy:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_data("res://Data/levelData.json")
	print(level_data)

func get_current_level_data() -> Dictionary:
	return level_data.get(str(current_level), {})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_level_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		level_data = JSON.parse_string(file.get_as_text())
		file.close()