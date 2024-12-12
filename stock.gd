@tool
extends Node3D
class_name Stock

@onready var meshInstance: CSGBox3D = get_node("mesh")

@export var size: Vector3 = Vector3(1,1,1):
	set(val):
		size = val
		if Engine.is_editor_hint():
			meshInstance.size = size

@export var color: Color = Color8(255, 0, 21, 255):
	set(val):
		color = val
		if Engine.is_editor_hint():
			meshInstance.material.albedo_color = color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meshInstance.size = size
	meshInstance.material.albedo_color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(get_child(0))
	pass


func setColor(newColor: Color) -> void:
	meshInstance.material.albedo_color = newColor


func setXsize(x: float) -> void:
	meshInstance.size.x = x


func setYsize(y: float) -> void:
	meshInstance.size.y = y


func setZsize(z: float) -> void:
	meshInstance.size.z = z


func offsetX(offset: float) -> void:
	var delta = position.x - offset
	position.x = offset
	get_node("mesh/csgMeshes").position.x += delta


func offsetY(offset: float) -> void:
	var delta = position.y - offset
	position.y = offset
	get_node("mesh/csgMeshes").position.y += delta


func offsetZ(offset: float) -> void:
	var delta = position.z - offset
	position.z = offset
	get_node("mesh/csgMeshes").position.z += delta
