extends TextureButton
@onready var cost_lbl = $CostLBL
@export var unit_name: String = "Soldier"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("unit_bought", self.update_button_cost)
	var unit_cost = UnitManager.unit_cost_dict.get(unit_name, 0)
	cost_lbl.text = "Cost:"	+ str(unit_cost)

func update_button_cost(unit_name: String) -> void:
	var unit_cost = UnitManager.unit_cost_dict.get(unit_name, 0)
	cost_lbl.text = "Cost:" + str(unit_cost)
