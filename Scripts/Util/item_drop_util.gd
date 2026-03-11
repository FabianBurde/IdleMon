extends TextureRect

var item_resource: ItemRes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item_resource:
		self.texture = item_resource.item_tex
	var spawn_tween = self.create_tween()
	self.scale = Vector2(0.2, 0.2)
	spawn_tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	position = Vector2(randf_range(5.0,150.0),randf_range(5.0,25.0))

func pickup_item():
	SignalBus.item_added_to_inventory.emit(item_resource)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
