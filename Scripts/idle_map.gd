extends Control

var dmg_num_util = preload("res://Scenes/Util/DmgNumUtil.tscn")

@export var game_scene:Node3D
@onready var monster_health_bar:TextureProgressBar = %MonsterHealthBar
@onready var monster_health_lbl:Label = %MonsterHealthLabel
@onready var gold_lbl:RichTextLabel = %GoldLabel
@onready var level_lbl:Label = %LevelLabel
@onready var exp_bar:TextureProgressBar = %ExpBar
@onready var army_container:HBoxContainer = %ArmyContainer
@onready var lvl_progress_lbl:Label = %LevelProgressLabel



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_ui_info.connect(update_ui_info)
	SignalBus.units_loaded.connect( load_army_units )
	SignalBus.unit_attack.connect(attack_emeny)
	ResourceManager.load_savefile()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui_info(gold, experience, level,lvlprogress) -> void:
	gold_lbl.text = str(gold)
	level_lbl.text = "Level %d\n Exp:%d \n Attack: %d" % [level, experience, ResourceManager.player_stats["attack"]]	
	var exp_to_next_level = level * 10
	exp_bar.value = experience
	exp_bar.max_value = (exp_to_next_level)
	lvl_progress_lbl.text = "Level Progress: %d%%" % [lvlprogress]
func player_attack() -> void:
	attack_emeny(ResourceManager.player_stats["attack"])

func attack_emeny(attack_value) -> void:
	if !game_scene.current_monster:
		return
	print("Attack Enemy")
	var num = dmg_num_util.instantiate()
	num.global_position = get_viewport().get_mouse_position()
	num.global_position.y -= randi() % 20
	add_child(num)
	game_scene.current_monster.take_damage(attack_value)
	monster_health_bar.value = game_scene.current_monster.current_health
	monster_health_lbl.text = str(game_scene.current_monster.current_health)


func buy_unit_01() -> void:
	var unit_cost = UnitManager.unit_cost_dict["Soldier"]
	if ResourceManager.global_gold >= unit_cost:
		UnitManager.unit_cost_dict["Soldier"] += 1
		SignalBus.unit_bought.emit("Soldier")
		ResourceManager.add_gold(-unit_cost)
		var unit_icon = preload("res://Scenes/Util/ArmyUnitUtil.tscn").instantiate()
		army_container.add_child(unit_icon)
		unit_icon.call_deferred("_set_random_stats", 10, 100)
		ResourceManager.entity_dict[unit_icon.get_instance_id()] = unit_icon.army_unit
		#unit_icon.unit_name_lbl.text = "Soldier"
		#unit_icon.unit_level_lbl.text = "Lvl 1"
	else:
		print("Not enough gold to buy unit.")

func load_army_units() -> void:
	for unit in ResourceManager.entity_dict.keys():
		var unit_icon = preload("res://Scenes/Util/ArmyUnitUtil.tscn").instantiate()
		unit_icon.army_unit = ResourceManager.entity_dict[unit]
		army_container.add_child(unit_icon)
		#quick fix because enemy spawn signal fires before units are fully ready
		SignalBus.enemy_spawned.emit()
		
		#unit_icon.call_deferred("_update_tooltip_text")
		#unit_icon.unit_name_lbl.text = "Soldier"
		#unit_icon.unit_level_lbl.text = "Lvl 1"

### TODO DELETE LATER ###
func manual_save() -> void:
	ResourceManager.save_game()

func manual_load() -> void:
	ResourceManager.load_savefile()
