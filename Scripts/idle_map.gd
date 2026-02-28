extends Control

const MAX_ARMY_SIZE = 40

var dmg_num_util = preload("res://Scenes/Util/DmgNumUtil.tscn")
var unit_scene = preload("res://Scenes/Util/ArmyUnitUtil.tscn")
var unit_slot_scene = preload("res://Scenes/Util/UnitSlot.tscn")

@export var game_scene:Node3D
@onready var monster_health_bar:TextureProgressBar = %MonsterHealthBar
@onready var monster_health_lbl:Label = %MonsterHealthLabel
@onready var gold_lbl:RichTextLabel = %GoldLabel
@onready var level_lbl:Label = %LevelLabel
@onready var exp_bar:TextureProgressBar = %ExpBar
@onready var army_container:GridContainer = %ArmyContainer
@onready var lvl_progress_lbl:Label = %LevelProgressLabel
@onready var lvl_name_lbl:Label = %LevelNameLabel
@onready var monster_btn:TextureButton =  %MonsterBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ResourceManager.new_game:
		load_army_slots()
	SignalBus.update_ui_info.connect(update_ui_info)
	SignalBus.units_loaded.connect( load_army_units )
	SignalBus.unit_attack.connect(attack_emeny)
	SignalBus.enemy_spawned.connect(update_enemy_health_bar)
	SignalBus.level_advanced.connect(update_level_name)
	SignalBus.unit_merged.connect(add_merged_unit)
	ResourceManager.load_savefile()
	update_level_name()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_ui_info(gold, experience, level,lvlprogress) -> void:
	gold_lbl.text = ("[color=orange]G:[/color] [color=yellow]%s[/color]" % str(gold))
	level_lbl.text = "Level %d\n Exp:%d \n Attack: %d" % [level, experience, ResourceManager.player_stats["attack"]]	
	var exp_to_next_level = level * 10
	exp_bar.value = experience
	exp_bar.max_value = (exp_to_next_level)
	lvl_progress_lbl.text = "Stage Progress: %d%% / %d" % [lvlprogress, LevelManager.level_data["levels"][LevelManager.current_level]["enemy_amount"]]
func player_attack() -> void:
	attack_emeny(ResourceManager.player_stats["attack"])

func update_enemy_health_bar() -> void:
	if game_scene.current_monster == null:
		return
	monster_health_bar.max_value = game_scene.current_monster.max_health
	monster_health_bar.value = game_scene.current_monster.current_health
	monster_health_lbl.text = str("%0.2f/%0.2f" % [game_scene.current_monster.current_health, game_scene.current_monster.max_health])

func update_level_name() -> void:
	var level_name = LevelManager.level_data["levels"][LevelManager.current_level]["level_name"]
	lvl_name_lbl.text = " Level %d: %s" % [LevelManager.current_level, level_name]


func attack_emeny(attack_value) -> void:
	if !game_scene.current_monster:
		return
	#print("Attack Enemy")
	var num = dmg_num_util.instantiate()
	num.global_position = get_viewport().get_mouse_position()
	num.global_position = monster_btn.global_position
	num.global_position.x += randi() %165
	num.global_position.y += randi() % 120
	num.dmg_num = attack_value
	add_child(num)
	game_scene.current_monster.take_damage(attack_value)
	monster_health_bar.value = game_scene.current_monster.current_health
	monster_health_lbl.text = str((game_scene.current_monster.current_health), "/" , str(game_scene.current_monster.max_health))


func buy_unit_01() -> void:
	var unit_cost = UnitManager.unit_cost_dict["Soldier"]
	if ResourceManager.global_gold >= unit_cost:
		## get next free slot
		var available_slot = -1
		for i in range(UnitManager.unit_slots.size()):
			if UnitManager.unit_slots[i] == null:
				available_slot = i
				break
		if available_slot == -1:
			print("No available unit slot!")
			return	
		UnitManager.unit_cost_dict["Soldier"] += 1
		SignalBus.unit_bought.emit("Soldier")
		ResourceManager.add_gold(-unit_cost)
		var unit_icon = unit_scene.instantiate()
		var unit_res = UnitRes.new()
		unit_res.unit_name = "Soldier"
		unit_res.base_stat_points = 100
		unit_res._set_random_stats(10, 100)
		unit_res._set_unit_texture(UnitManager.unit_01)
		unit_res.star_value = 1
		unit_res.health = 100.0
		unit_res.unit_id = ResourceManager.entity_id_counter
		unit_res.unit_slot_id = available_slot
		UnitManager.unit_slots[available_slot] = unit_icon
		unit_icon.army_unit = unit_res

		army_container.get_children()[available_slot].add_child(unit_icon)
		ResourceManager.entity_dict[ResourceManager.entity_id_counter] = inst_to_dict(unit_icon.army_unit)
		ResourceManager.entity_id_counter += 1
		#unit_icon.army.text = "Soldier"
		#unit_icon.unit_level_lbl.text = "Lvl 1"
		print("ID: ", unit_icon.army_unit.unit_id, " Name: ", unit_icon.army_unit.unit_name)
	else:
		print("Not enough gold to buy unit.")

func add_merged_unit(new_unit:UnitRes) -> void:
	reorder_army_units()
	var unit_icon = unit_scene.instantiate()
	unit_icon.army_unit = new_unit
	unit_icon.army_unit.star_value = new_unit.star_value
	unit_icon.army_unit.unit_id = ResourceManager.entity_id_counter
	for slot in range(army_container.get_child_count()-1):
		if UnitManager.unit_slots[slot] == null:
			UnitManager.unit_slots[slot] = unit_icon
			unit_icon.army_unit.unit_slot_id = slot
			army_container.get_child(slot).add_child(unit_icon)
			break
	#army_container.add_child(unit_icon)
	ResourceManager.entity_dict[ResourceManager.entity_id_counter] = inst_to_dict(unit_icon.army_unit)
	ResourceManager.entity_id_counter += 1
	#unit_icon.update_star_progress(unit_icon.army_unit.star_val)

func reorder_army_units():
	var slots = army_container.get_children()
	for i in range(slots.size()):
		if UnitManager.unit_slots[i] == null:
			for j in range(i+1, slots.size()-1):
				if UnitManager.unit_slots[j] != null:
					UnitManager.unit_slots[i] = UnitManager.unit_slots[j]
					UnitManager.unit_slots[j] = null
					UnitManager.unit_slots[i].army_unit.unit_slot_id = i
					var swap_unit = slots[j].get_child(0)
					swap_unit.update_res_dict()
					swap_unit.reparent(slots[i], false)
					break

func load_army_units() -> void:
	load_army_slots()
	for unit in ResourceManager.entity_dict.keys():
		var unit_icon = unit_scene.instantiate()
		unit_icon.army_unit = dict_to_inst(ResourceManager.entity_dict[unit])
		#unit_icon.unit_id = unit
		if ResourceManager.entity_dict[unit]["unit_slot_id"] != null:
			UnitManager.unit_slots[ResourceManager.entity_dict[unit]["unit_slot_id"]] = unit_icon

		var slots = army_container.get_children()
		for slot in range(slots.size()):
				if unit_icon.army_unit.unit_slot_id == slot:
					slots[slot].add_child(unit_icon)

		unit_icon.spawn_position = unit_icon.global_position
		#quick fix because enemy spawn signal fires before units are fully ready
	SignalBus.enemy_spawned.emit()

func load_army_slots() -> void:
	UnitManager.unit_slots.resize(ResourceManager.unit_slots_unlocked)
	UnitManager.unit_slots.fill(null)
	#print(UnitManager.unit_slots)
	for i in range(ResourceManager.unit_slots_unlocked):
		var slot = unit_slot_scene.instantiate()
		army_container.add_child(slot)

### TODO DELETE LATER ###
func manual_save() -> void:
	ResourceManager.save_game()

func manual_load() -> void:
	ResourceManager.load_savefile()
