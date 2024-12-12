extends HSplitContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_test_code_pressed() -> void:
	#ParseGcode.parseCode(get_node("Panel/TextEdit").text)
	pass


func hideAll() -> void:
	get_tree().root.get_node("World/stockEdit").visible = false
	get_tree().root.get_node("World/spindle_edit").visible = false
	get_node("VBoxContainer/FileDialog").visible = false


func _on_edit_stock_pressed() -> void:
	var node = get_tree().root.get_node("World/stockEdit")
	if node.visible == true:
		hideAll()
	else:
		hideAll()
		node.visible = true


func _on_edit_spindle_pressed() -> void:
	var node = get_tree().root.get_node("World/spindle_edit")
	if node.visible == true:
		hideAll()
	else:
		hideAll()
		node.visible = true


func _on_load_gcode_pressed() -> void:
	var node = get_node("VBoxContainer/FileDialog")
	if node.visible == true:
		hideAll()
	else:
		hideAll()
		node.visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	get_node("Panel/TextEdit").text = content
