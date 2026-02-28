extends Control

var available_resolutions: Array = [Vector2(800, 600), Vector2(1024, 768), Vector2(1280, 720), Vector2(1920, 1080)]
@onready var resolution_dropdown: OptionButton =  $Settings/VBoxContainer/ResolutionSelect
@onready var setttings_menu: Control = %Settings
@onready var buttons_menu: VBoxContainer = %BtnContainer
@onready var game_slots_menu: VBoxContainer = %GameSlots
var config = ConfigFile.new()

@onready var slot1_stats = %Slot1Stats
@onready var slot2_stats = %Slot2Stats
@onready var slot3_stats = %Slot3Stats


const SAVE_01:= "user://SaveSlot1.tres"
const SAVE_02:= "user://SaveSlot2.tres"
const SAVE_03:= "user://SaveSlot3.tres"
var save_game: SaveGame = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(available_resolutions)
	var err = config.load("res://settings.cfg")
	if err != OK:
		return
	for item in available_resolutions:
		var res_text = str(int(item.x)) + " x " + str(int(item.y))
		resolution_dropdown.add_item(res_text)
	var current_resolution = config.get_value("display", "resolution", DisplayServer.screen_get_size())
	get_tree().root.set_size(current_resolution)
	get_viewport().set_size(current_resolution)
	get_tree().root.set_position(DisplayServer.screen_get_size() / 2 - Vector2i(current_resolution) / 2)
	#ProjectSettings.set_setting("display/window/size/viewport_width",current_resolution[0])
	#ProjectSettings.set_setting("display/window/size/viewport_height",current_resolution[1])
	resolution_dropdown.select(available_resolutions.bsearch(config.get_value("display", "resolution", Vector2(1024, 768))))



func change_resolution(index: int) -> void:
	var selected_resolution = available_resolutions[index]
	get_tree().root.set_size(selected_resolution)
	get_viewport().set_size(selected_resolution)
	print(selected_resolution)
	get_tree().root.set_position(DisplayServer.screen_get_size() / 2 - Vector2i(selected_resolution) / 2)
	DisplayServer.window_set_size(selected_resolution)
	#DisplayServer.window_set_position(DisplayServer.window_get_position() - DisplayServer.window_get_size() / 2 + DisplayServer.screen_get_size() / 2)
	#get_viewport().set_size(selected_resolution)
	#ProjectSettings.set_setting("display/window/size/viewport_width",selected_resolution[0])
	#ProjectSettings.set_setting("display/window/size/viewport_height",selected_resolution[1])
	config.set_value("display", "resolution", selected_resolution)
	config.save("res://settings.cfg")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_Start() -> void:
	# Show Gameslots
	buttons_menu.visible = false
	#for child in game_slots_menu.get_children(()
	if ResourceLoader.exists(SAVE_01):
		save_game = ResourceLoader.load(SAVE_01,"",ResourceLoader.CACHE_MODE_IGNORE)
		slot1_stats.text = str(save_game.global_gold)
	else:
		slot1_stats.text = "EMPTY"
	if ResourceLoader.exists(SAVE_02):
		save_game = ResourceLoader.load(SAVE_02,"",ResourceLoader.CACHE_MODE_IGNORE)
		slot2_stats.text = str(save_game.global_gold)
	else:
		slot2_stats.text = "EMPTY"
	if ResourceLoader.exists(SAVE_03):
		save_game = ResourceLoader.load(SAVE_03,"",ResourceLoader.CACHE_MODE_IGNORE)
		slot3_stats.text = str(save_game.global_gold)
	else:
		slot3_stats.text = "EMPTY"
				
			

	game_slots_menu.visible = true

	pass

func load_game_slot_01():
	### For saves in Savefiles show slots ###
	print("test")
	if ResourceLoader.exists("user://SaveSlot1.tres"):
		ResourceManager.active_save_file_path = "user://SaveSlot1.tres"
		ResourceManager.active_save_game = ResourceLoader.load("user://SaveSlot1.tres","",ResourceLoader.CACHE_MODE_IGNORE)
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")
		ResourceManager.load_savefile()
	else:
		ResourceManager.active_save_game = SaveGame.new()
		ResourceManager.active_save_file_path = "user://SaveSlot1.tres"
		ResourceManager.new_game = true
		ResourceSaver.save(ResourceManager.active_save_game,"user://SaveSlot1.tres")
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")

func load_game_slot_02():
	### For saves in Savefiles show slots ###
	print("test")
	if ResourceLoader.exists("user://SaveSlot2.tres"):
		ResourceManager.active_save_file_path = "user://SaveSlot2.tres"
		ResourceManager.active_save_game = ResourceLoader.load("user://SaveSlot2.tres","",ResourceLoader.CACHE_MODE_IGNORE)
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")
		ResourceManager.load_savefile()
	else:
		ResourceManager.active_save_game = SaveGame.new()
		ResourceManager.active_save_file_path = "user://SaveSlot2.tres"
		ResourceManager.new_game = true
		ResourceSaver.save(ResourceManager.active_save_game,"user://SaveSlot2.tres")
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")

func load_game_slot_03():
	### For saves in Savefiles show slots ###
	print("test")
	if ResourceLoader.exists("user://SaveSlot3.tres"):
		ResourceManager.active_save_file_path = "user://SaveSlot3.tres"
		ResourceManager.active_save_game = ResourceLoader.load("user://SaveSlot3.tres","",ResourceLoader.CACHE_MODE_IGNORE)
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")
		ResourceManager.load_savefile()
	else:
		ResourceManager.active_save_game = SaveGame.new()
		ResourceManager.active_save_file_path = "user://SaveSlot3.tres"
		ResourceManager.new_game = true
		get_tree().change_scene_to_file("res://Scenes/IdleMap.tscn")
		ResourceSaver.save(ResourceManager.active_save_game,"user://SaveSlot3.tres")

func on_Settings() -> void:
	# Show Settings Menu
	if setttings_menu.visible:
		setttings_menu.visible = false
		buttons_menu.visible = true
	else:
		buttons_menu.visible = false
		setttings_menu.visible = true
func on_Exit() -> void:
	get_tree().quit()


func new_save_file() -> void:
	pass
