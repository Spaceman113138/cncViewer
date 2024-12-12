extends Camera3D
class_name CameraController

var rot_x = 0
var rot_y = 0


const translateSpeed = 0.075
const LOOKAROUND_SPEED = 0.004
const scrollSpeed = 0.5


func _process(_delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rot_x += event.relative.x * LOOKAROUND_SPEED
		rot_y += event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
	
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		var mouseTranslation = event.relative * position.distance_to(Vector3.ZERO)
		var translateCam: Vector3 = Vector3(-mouseTranslation.x, mouseTranslation.y, 0).normalized()
		translate(translateCam * translateSpeed)

	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
			translate(Vector3.FORWARD * scrollSpeed)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
			translate(Vector3.BACK * scrollSpeed)
