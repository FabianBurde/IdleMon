extends Node

var level_data = {}
var current_level: int = 0
var enemies_in_level_killed: int
var	bosses_killed: int = 0

var active_enemy:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_data("res://Data/levelData.json")
	print(level_data)
	SignalBus.level_advanced.connect( advance_level )

func get_current_level_data() -> Dictionary:
	return level_data.get(str(current_level), {})

func advance_level() -> void:
	current_level += 1
	enemies_in_level_killed = 0
	bosses_killed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_level_data(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		level_data = JSON.parse_string(file.get_as_text())
		file.close()
