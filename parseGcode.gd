extends Node
class_name ParseGcode


static func parseCode(rawGcode: String):
	var splitRawGcode: PackedStringArray = []
	for line in rawGcode.split("\n", false):
		splitRawGcode.append(line.split(";")[0])
		
	var commandArray: Array[Dictionary] = []
	var lineIndex: int = 1
	for line: String in splitRawGcode:
		var commands: PackedStringArray = line.split(" ", false)
		var nextNeededCommand: Array = [" "]
		var comandDict: Dictionary = {}
		for command in commands:
			var commandChar = command.substr(0,1)
			match commandChar:
				"N", "n" when nextNeededCommand.pop_front() == " ":
					var array = parseNcode(command)
					if array.size() == 0:
						return
					if !comandDict.has("command"):
						comandDict["command"] = " "
					comandDict[array[0]] = array[1]
					nextNeededCommand = array[2]
				"G", "g" when nextNeededCommand.pop_front() == " ":
					var array = parseGcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
					nextNeededCommand = array[2]
				"X", "x" when nextNeededCommand.pop_front() == "x":
					var array = parseXcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				"Y", "y" when nextNeededCommand.pop_front() == "y":
					var array = parseYcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				"Z", "z" when nextNeededCommand.pop_front() == "z":
					var array = parseZcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				"I", "i" when nextNeededCommand.pop_front() == "i":
					var array = parseIcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				"J", "j" when nextNeededCommand.pop_front() == "j":
					var array = parseJcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				"F", "f" when nextNeededCommand.pop_front() == "f":
					var array = parseFcode(command)
					if array.size() == 0:
						return
					comandDict[array[0]] = array[1]
				_:
					push_error("invalid " + commandChar + " command at line: " + str(lineIndex))
		if nextNeededCommand.size() > 0:
			if nextNeededCommand[0] != " ":
				push_error("Missing commands: " + str(nextNeededCommand))
				return
		commandArray.append(comandDict)
	print(commandArray)
	return commandArray


static func parseGcode(command: String) -> Array:
	var index: String = command.trim_prefix("g")
	index = index.trim_prefix("G")
	if !index.is_valid_int():
		push_error("Invalid G code")
		return []
	match index.to_int():
		0:
			return ["command", "fMove", ["x", "y", "z"]]
		1:
			return ["command", "lMove", ["x", "y", "z", "f"]]
		2:
			return ["command", "cwMove", ["x", "y", "z", "i", "j", "f"]]
		3:
			return ["command", "ccwMove", ["x", "y", "z", "i", "j", "f"]]
		20:
			return ["command", "inches", [" "]]
		90:
			return ["command", "absolute", [" "]]
		91:
			return ["command", "reletive", [" "]]
		_:
			push_error("Invalid G code")
			return []

static func parseXcode(command: String) -> Array:
	var value: String = command.trim_prefix("X")
	value = value.trim_prefix("x")
	if !value.is_valid_float():
		push_error("invalid X code")
		return []
	return ["x", value.to_float()]


static func parseNcode(command: String) -> Array:
	var value: String = command.trim_prefix("N")
	value = value.trim_prefix("n")
	if !value.is_valid_float():
		push_error("invalid N code")
		return []
	return ["n", value.to_float(), [" "]]


static func parseYcode(command: String) -> Array:
	var value: String = command.trim_prefix("Y")
	value = value.trim_prefix("y")
	if !value.is_valid_float():
		push_error("invalid Y code")
		return []
	return ["y", value.to_float()]


static func parseZcode(command: String) -> Array:
	var value: String = command.trim_prefix("Z")
	value = value.trim_prefix("z")
	if !value.is_valid_float():
		push_error("invalid Z code")
		print(value)
		return []
	return ["z", value.to_float()]


static func parseIcode(command: String) -> Array:
	var value: String = command.trim_prefix("I")
	value = value.trim_prefix("i")
	if !value.is_valid_float():
		push_error("invalid I code")
		return []
	return ["i", value.to_float()]


static func parseJcode(command: String) -> Array:
	var value: String = command.trim_prefix("J")
	value = value.trim_prefix("j")
	if !value.is_valid_float():
		push_error("invalid J code")
		return []
	return ["j", value.to_float()]


static func parseFcode(command: String) -> Array:
	var value: String = command.trim_prefix("F")
	value = value.trim_prefix("f")
	if !value.is_valid_float():
		push_error("invalid f code")
		return []
	return ["f", value.to_float()]
