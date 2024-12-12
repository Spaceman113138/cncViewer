extends Control
class_name SpindleEdit


@onready var spindle: Spindle = get_tree().root.get_node("World/spindle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("GridContainer/diameter edit").text = str(spindle.getDiameter())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_diameter_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		spindle.setDiameter(new_text.to_float())
	if testFraction(new_text) != null:
		spindle.setDiameter(testFraction(new_text))



func testFraction(posFrac: String):
	var fracArray: PackedStringArray = posFrac.replace(" ", "").split("/")
	if fracArray.size() == 2:
		if fracArray[0].is_valid_float() and fracArray[1].is_valid_float():
			return fracArray[0].to_float() / fracArray[1].to_float()
	
	return null
