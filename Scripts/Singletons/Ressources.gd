class_name  Ressources
extends Node

var global_gold: int = 10
var max_level_progress: = 1
var entity_dict = {}
var player_stats = {
	"lvl": 1,
	"exp": 0,
	"attack": 1,
}
var save_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"])
	save_timer = Timer.new()
	save_timer.wait_time = 30.0
	save_timer.one_shot = false
	save_timer.autostart = true
	add_child(save_timer)
	save_timer.start()
	save_timer.timeout.connect( save_game )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_gold(amount: int) -> void:
	global_gold += amount
	SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"])

func add_exp(amount:int) -> void:
	player_stats["exp"] += amount
	var exp_to_next_level = player_stats["lvl"] * 10
	if player_stats["exp"] >= exp_to_next_level:
		player_stats["exp"] -= exp_to_next_level
		player_stats["lvl"] += 1
		player_stats["attack"] += 1
		max_level_progress = max(max_level_progress, player_stats["lvl"])
		SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"])


func load_savefile(path: String) -> void:
	var save_data = load(path)
	if save_data:
		pass

func new_save_file():
	pass

func save_game(path: String) -> void:
	var save_data = {}
	path = "res://Data/savefiles/savefile.res"
	save_data["global_gold"] = global_gold
	save_data["max_level_progress"] = max_level_progress
	save_data["entity_dict"] = entity_dict
	save_data["player_stats"] = player_stats
	print(save_data)