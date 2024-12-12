extends Node
class_name CSGMeshes

static var stepSize: float = .1

static func arc(center: Vector3, radius: float, width: float, sAngle: float, eAngle: float, cw: bool):
	var interiorRad = radius - (width/2)
	var exteriorRad = radius + (width/2)
	
	var node: CSGPolygon3D = CSGPolygon3D.new()
	node.rotate_x(deg_to_rad(90))
	node.operation = CSGShape3D.OPERATION_UNION
	node.position = center
	var pointArray: PackedVector2Array = []
	
	if cw:
		var cAngle: float = sAngle
		while cAngle <= eAngle:
			var x = cos(cAngle) * interiorRad
			var y = sin(cAngle) * interiorRad
			pointArray.append(Vector2(x,y))
			cAngle += stepSize
		cAngle = eAngle
		while cAngle >= sAngle:
			var x = cos(cAngle) * exteriorRad
			var y = sin(cAngle) * exteriorRad
			pointArray.append(Vector2(x,y))
			cAngle -= stepSize
	else:
		var cAngle: float = sAngle
		while cAngle >= eAngle:
			var x = cos(cAngle) * interiorRad
			var y = sin(cAngle) * interiorRad
			pointArray.append(Vector2(x,y))
			cAngle -= stepSize
		cAngle = eAngle
		while cAngle <= sAngle:
			var x = cos(cAngle) * exteriorRad
			var y = sin(cAngle) * exteriorRad
			pointArray.append(Vector2(x,y))
			cAngle += stepSize
	node.polygon = pointArray
	return node
	

static func line(start: Vector3, end: Vector3, width: float) -> CSGBox3D:
	var midpoint: Vector3 = (start + end) / 2
	var angle = atan2(midpoint.z - start.z, midpoint.x - start.x)
	var node: CSGBox3D = CSGBox3D.new()
	node.operation = CSGShape3D.OPERATION_UNION
	node.size = Vector3(max(start.distance_to(end),width), 1, width)
	node.position = midpoint + Vector3(0,node.size.y/2,0)
	node.rotate_y(-angle + 0.00174532925)
	
	return node


static func cylinder(pos: Vector3, width: float) -> CSGCylinder3D:
	var node: CSGCylinder3D = CSGCylinder3D.new()
	node.operation = CSGShape3D.OPERATION_UNION
	node.radius = width/2
	node.position = pos
	node.position.y += node.height/2
	return node
