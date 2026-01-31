class_name  Ressources
extends Node

var global_gold: int = 10
var max_level_progress: = 1 # move to level manager?
var entity_dict = {}
var player_stats = {
	"lvl": 1,
	"exp": 0,
	"attack": 1,
}
var save_timer: Timer
var active_save_game: SaveGame = null
var active_save_file_path: String = ""

enum DebugModes {
	OFF,
	INFO,
	VERBOSE
}
var debug_mode: DebugModes = DebugModes.OFF
var new_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"],LevelManager.enemies_killed)
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
	SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"],LevelManager.enemies_killed)

func add_exp(amount:int) -> void:
	player_stats["exp"] += amount
	var exp_to_next_level = player_stats["lvl"] * 10
	if player_stats["exp"] >= exp_to_next_level:
		player_stats["exp"] -= exp_to_next_level
		player_stats["lvl"] += 1
		player_stats["attack"] += 1
		max_level_progress = max(max_level_progress, player_stats["lvl"])
		SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"],LevelManager.enemies_killed)


func load_savefile() -> void:
	if active_save_game == null or new_game:
		return
	global_gold = active_save_game.global_gold
	max_level_progress = active_save_game.max_level_progress
	entity_dict = active_save_game.entity_dict
	player_stats = active_save_game.player_stats
	UnitManager.unit_cost_dict = active_save_game.units_cost_dict
	SignalBus.update_ui_info.emit(global_gold, player_stats["exp"], player_stats["lvl"],LevelManager.enemies_killed)
	SignalBus.units_loaded.emit()
	
func new_save_file():
	pass

func save_game() -> void:
	if active_save_game == null:
		return
	active_save_game.global_gold = global_gold
	active_save_game.max_level_progress = max_level_progress
	active_save_game.entity_dict = entity_dict
	active_save_game.player_stats = player_stats
	active_save_game.units_cost_dict = UnitManager.unit_cost_dict
	ResourceSaver.save(active_save_game, active_save_file_path)
	print("Game Saved to ", active_save_file_path)
