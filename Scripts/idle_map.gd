extends Control

var dmg_num_util = preload("res://Scenes/Util/DmgNumUtil.tscn")

@export var game_scene:Node3D
@onready var monster_health_bar:TextureProgressBar = %MonsterHealthBar
@onready var monster_health_lbl:Label = %MonsterHealthLabel
@onready var gold_lbl:RichTextLabel = %GoldLabel
@onready var level_lbl:Label = %LevelLabel
@onready var exp_bar:TextureProgressBar = %ExpBar
@onready var army_container:HBoxContainer = %ArmyContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_ui_info.connect(update_ui_info)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui_info(gold, experience, level) -> void:
	gold_lbl.text = str(gold)
	level_lbl.text = "Level " + str(level)
	var exp_to_next_level = level * 10
	exp_bar.value = experience
	exp_bar.max_value = exp_to_next_level

func attack_emeny() -> void:
	if !game_scene.current_monster:
		return
	print("Attack Enemy")
	var num = dmg_num_util.instantiate()
	num.global_position = get_viewport().get_mouse_position()
	num.global_position.y -= randi() % 20
	add_child(num)
	game_scene.current_monster.take_damage(ResourceManager.player_stats["attack"])
	monster_health_bar.value = game_scene.current_monster.current_health
	monster_health_lbl.text = str(game_scene.current_monster.current_health)


func buy_unit_01() -> void:
	var unit_cost = 2
	if ResourceManager.global_gold >= unit_cost:
		ResourceManager.add_gold(-unit_cost)
		var unit_icon = preload("res://Scenes/Util/ArmyUnitUtil.tscn").instantiate()
		army_container.add_child(unit_icon)
		#unit_icon.unit_name_lbl.text = "Soldier"
		#unit_icon.unit_level_lbl.text = "Lvl 1"
	else:
		print("Not enough gold to buy unit.")
