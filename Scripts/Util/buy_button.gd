extends TextureButton

@onready var name_lbl = $Name
@onready var cost_lbl = $CostLBL
@export var unit_name: String = "Soldier"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("unit_bought", self.update_button_cost)
	var unit_cost = UnitManager.unit_cost_dict.get(unit_name, 0)
	name_lbl.text = unit_name
	cost_lbl.text = "Cost:"	+ str(unit_cost)

func update_button_cost(unit_name: String) -> void:
	var unit_cost = UnitManager.unit_cost_dict.get(unit_name, 0)
	cost_lbl.text = "Cost:" + str(unit_cost)


func btn_hovered():
	self.scale = Vector2(1.1, 1.1)
	self.modulate = Color(1, 1, 1, 0.8)

func btn_unhovered():
	self.scale = Vector2(1, 1)
	self.modulate = Color(1, 1, 1, 1)