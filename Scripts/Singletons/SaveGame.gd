class_name SaveGame
extends Resource

@export var global_gold: int = 0
@export var unit_slots_unlocked: int = 4
@export var max_level_progress: int = 1
@export var enemies_killed_in_level: int = 0
@export var entity_dict: Dictionary = {}
@export var entity_id_counter: int = 0
@export var player_stats: Dictionary = {}
@export var units_cost_dict: Dictionary = {}