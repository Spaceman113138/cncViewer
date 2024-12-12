extends Control


@onready var stock: Stock = get_tree().root.get_node("World/Stock")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("GridContainer/xEdit").text = str(stock.size.x)
	get_node("GridContainer/yEdit").text = str(stock.size.y)
	get_node("GridContainer/zEdit").text = str(stock.size.z)
	get_node("GridContainer/xOffsetEdit").text = str(stock.position.x)
	get_node("GridContainer/yOffsetEdit").text = str(stock.position.y)
	get_node("GridContainer/zOffsetEdit").text = str(stock.position.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_color_picker_color_changed(color: Color) -> void:
	stock.setColor(color)


func _on_x_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.setXsize(new_text.to_float())


func _on_y_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.setYsize(new_text.to_float())


func _on_z_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.setZsize(new_text.to_float())


func _on_x_offset_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.offsetX(new_text.to_float())


func _on_y_offset_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.offsetY(new_text.to_float())


func _on_z_offset_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		stock.offsetZ(-new_text.to_float())
