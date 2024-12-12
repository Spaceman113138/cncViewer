extends Node3D
class_name world

var startingPos: Vector3 = Vector3.ZERO
var target: Vector3 = Vector3.ZERO
var center: Vector3 = Vector3.ZERO
var atTarget: bool = false
var absolute: bool = true
var step: float = 0
var linear: bool = true
var initialAngle: float = 0
var finalAngle: float = 0
var cw: bool = true
var radius: float = 1
var stepSize: float = .1
var commands = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("GUI/VBoxContainer/HBoxContainer/test code").connect("pressed", runCode)
	startingPos = get_node("spindle").position
	target = get_node("spindle").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	if target.is_equal_approx(get_node("spindle").getPosition()):
		atTarget = true
		step = 0
		startingPos = target
		if commands != null and commands.size() > 0:
			parseNextCode()
	else:
		atTarget = false
	
	if !atTarget:
		if linear:
			get_node("spindle").setPosition(startingPos.lerp(target, step))
			step += stepSize
			step = clamp(step, 0, 1)

		if !linear:
			var newAngle: float = clamp(lerpf(initialAngle, finalAngle, step), min(initialAngle, finalAngle), max(finalAngle, initialAngle))
			var x: float = cos(newAngle) * radius
			var y: float = sin(newAngle) * radius
			get_node("spindle").setPosition(Vector3(x + center.x, startingPos.y + center.y, y + center.z))
			step += stepSize
			if newAngle == finalAngle:
				linear = true
				atTarget = false
				step = 0
				startingPos = get_node("spindle").getPosition()
		
		


func runCode() -> void:
	get_node("spindle").setPosition(Vector3(0, 2, 0))
	for child in get_node("Stock/mesh/csgMeshes").get_children():
		print(child)
		child.queue_free()
	commands = ParseGcode.parseCode(get_node("GUI/Panel/TextEdit").text)
	if commands != null and commands.size() > 0:
		parseNextCode()


func parseNextCode() -> void:
	var width: float = get_tree().root.get_node("World/spindle").getDiameter()
	var command:Dictionary = commands.pop_front()
	startingPos = get_node("spindle").getPosition()
	match command["command"]:
		"fMove","lMove":
			target = Vector3(command["x"],command["z"],-command["y"])
			linear = true
			step = 0
			var length = startingPos.distance_to(target)
			if command.has("f"):
				stepSize = length / command["f"] * 60
				var node: CSGBox3D = CSGMeshes.line(startingPos, target, width)
				#node.position = -get_node("Stock").position
				get_tree().root.get_node("World/Stock/mesh/csgMeshes").add_child(node)
				#var cNode: CSGCylinder3D = CSGMeshes.cylinder(target, width)
				#get_tree().root.get_node("World/Stock/mesh").add_child(cNode)
			else:
				stepSize = length / 30 * 60
		"cwMove":
			linear = false
			if !is_equal_approx(command["z"], startingPos.y):
				push_error("curve changes z height")
				print([command["z"], startingPos.y])
				return
			target = Vector3(command["x"],command["z"], -command["y"])
			center = Vector3(command["i"],command["z"], -command["j"])
			radius = target.distance_to(center)
			initialAngle = atan2(startingPos.z - center.z, startingPos.x - center.x)
			finalAngle = atan2(target.z - center.z, target.x - center.x)
			if finalAngle < initialAngle:
				finalAngle += PI * 2
			isValidArc(center, radius, finalAngle, target)
			var circufrence = (2 * PI * radius) * ((finalAngle - initialAngle)/360)
			stepSize = circufrence / command["f"] * 60
			var node: CSGPolygon3D = CSGMeshes.arc(center,radius,width,initialAngle, finalAngle,true)
			#node.position = -get_node("stockEdit").position
			get_tree().root.get_node("World/Stock/mesh/csgMeshes").add_child(node)
		"ccwMove":
			linear = false
			if !is_equal_approx(command["z"], startingPos.y):
				push_error("curve changes z height")
				print([command["z"], startingPos.y])
				return
			target = Vector3(command["x"],command["z"], -command["y"])
			center = Vector3(command["i"],command["z"], -command["j"])
			radius = target.distance_to(center)
			initialAngle = atan2(startingPos.z - center.z, startingPos.x - center.x)
			finalAngle = atan2(target.z - center.z, target.x - center.x)
			if finalAngle > initialAngle:
				finalAngle -= PI * 2
			isValidArc(center, radius, finalAngle, target)
			var circufrence = (2 * PI * radius) * ((initialAngle - finalAngle)/360)
			stepSize = circufrence / command["f"] * 60
			var node: CSGPolygon3D = CSGMeshes.arc(center,radius,width,initialAngle, finalAngle,false)
			#node.position = -get_node("stockEdit").position
			get_tree().root.get_node("World/Stock/mesh/csgMeshes").add_child(node)
		"absolute":
			absolute = true
		"reletive":
			absolute = false
		_:
			print(command["command"])


func isValidArc(center: Vector3, radius: float, finalAngle: float, target: Vector3):
	var x: float = cos(finalAngle) * radius
	var y: float = sin(finalAngle) * radius
	var finalPos: Vector3 = Vector3(x + center.x, startingPos.z + center.y, y + center.z)
	if finalPos.is_equal_approx(target):
		push_warning("invalid arc")
