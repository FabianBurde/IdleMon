class_name InventoryItem
extends Moveable

@onready var item_sprite: TextureRect = $SpriteItem

var disabled: bool = false
var swap_target: InventoryItem = null
var item_data : ItemRes

var swap_ref: InventoryItem = null
var consume_ref: UnitContainer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disabled:
		self.modulate = Color(1, 1, 1, 0.1)
		scale_tween(0.8,Tween.TRANS_SINE)
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		item_sprite.texture = null
	else:
		item_sprite.texture = item_data.item_tex
		self.modulate = Color(1, 1, 1, 1)
		self.mouse_filter = Control.MOUSE_FILTER_STOP
		self.scale = Vector2(0.2, 0.2)
		#self.create_tween().tween_property(self, "scale", Vector2(1, 1), 1.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		scale_tween(1.6,Tween.TRANS_ELASTIC)
		set_tooltip()

func scale_tween(time: float,trans: Tween.TransitionType) -> void:
	self.scale = Vector2(0.2, 0.2)
	self.create_tween().tween_property(self, "scale", Vector2(1, 1), time).set_trans(trans).set_ease(Tween.EASE_OUT)

func set_tooltip() -> void:
	if item_data == null:
		tooltip_text = ""
		return
	tooltip_text = "%s\nValue: %d\nType: %s" % [item_data.name, item_data.value, str(item_data.type)]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func has_drop_target() -> bool:
	var mouse_pos = get_global_mouse_position()
	var parent = get_parent()
	for item in parent.inventory_items:
		if item.get_global_rect().has_point(mouse_pos) and item != self and !item.disabled:
			swap_ref = item
			return true
	for slot in UnitManager.army_container.get_children():
		for unit in slot.get_children():
			#print(unit.get_global_rect())
			if unit.get_global_rect().has_point(mouse_pos):
				consume_ref = unit
				return true
	
	return false

func stop_drag() -> void:
	dragging = false
	if has_drop_target():
		print("found target")
		if swap_ref:
			swap_items(swap_ref)
			swap_ref = null
		elif consume_ref:
			if item_data.type == ItemRes.ItemType.CONSUMABLE:
				consume()
			elif item_data.type == ItemRes.ItemType.EQUIPPABLE:
				equip()
			consume_ref = null

	else:
		self.global_position = drag_start_position

func swap_items(target: InventoryItem) -> void:
	if !target.disabled and target.item_data != null:
		var temp_data = target.item_data
		target.item_data = self.item_data
		self.item_data = temp_data
		item_sprite.texture = item_data.item_tex
		target.item_sprite.texture = target.item_data.item_tex
		set_tooltip()
	elif !target.disabled and target.item_data == null:
		target.item_data = self.item_data
		self.item_data = null
		self.item_sprite.texture = null
		target.item_sprite.texture =  target.item_data.item_tex
		self.mouse_filter = Control.MOUSE_FILTER_IGNORE
		target.mouse_filter = Control.MOUSE_FILTER_STOP
		set_tooltip()
	print(item_data)
	self.global_position = drag_start_position
	#update visuals here
	

func consume() -> void:
	#apply item effect
	#remove from inventory
	self.item_data = null
	self.item_sprite.texture = null
	self.global_position = drag_start_position
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_tooltip()

func equip() -> void:
	#apply item effect
	#remove from inventory
	item_data = null
	item_sprite.texture = null
	self.global_position = drag_start_position
	set_tooltip()
