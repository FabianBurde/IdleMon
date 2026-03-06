extends GridContainer

const MAX_SLOTS = 36
var available_slots:int
@onready var inventory_items: Array = []
@onready var item_scene: PackedScene = preload("res://Scenes/Util/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	available_slots = ResourceManager.inventory_slots
	for i in range(MAX_SLOTS):
		var slot = item_scene.instantiate() as InventoryItem
		if i >= available_slots:
			slot.disabled = true
		var data = ItemRes.new()
		### CHANGE TO ONLY RESOURCE LOADING
		data = AssetManager.get_item("health_potion_01")
		if i == 2:
			data = AssetManager.get_item("wood_chest_armor")
			print(data)
		slot.item_data = data
		add_child(slot)
		#self.create_tween().tween_property(slot, "scale", Vector2(1, 1), 0.5).set_delay(i * 1.05)
		inventory_items.append(slot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
