extends Node

signal enemy_dead
signal enemy_spawned
signal update_ui_info(gold,exp,level,lvlprogress)
signal unit_attack(attack_value)
signal game_loaded

signal units_loaded

signal unit_bought(unit_name: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
