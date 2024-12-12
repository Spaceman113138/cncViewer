extends Node3D
class_name Spindle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func setDiameter(diameter: float) -> void:
	get_node("spindleMesh").mesh.top_radius = diameter/2
	get_node("spindleMesh").mesh.bottom_radius = diameter/2


func getDiameter() -> float:
	return get_node("spindleMesh").mesh.top_radius * 2


func setPosition(newPosition: Vector3):
	position =  newPosition

func getPosition() -> Vector3:
	return position
