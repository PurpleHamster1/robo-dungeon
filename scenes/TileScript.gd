extends TileMap

@export var initialCharPos : Vector2i
@export var initialCharRot : int
@export var nextLevel : String
@export var commandsAv : Array

@onready var robot = $Character
@onready var commands = $"../../GUI/Background/VSplitContainer/Lines/VBoxContainer"
@onready var runButton = $"../../GUI/RunButton"
@onready var errorPanel = $"../../GUI/ErrorPanel"
@onready var arrow = $"../../GUI/Arrow"
@onready var mainNode = $"../.."
var tween
var errorIndex = -1
var ghostCode
var completed = false

func run_button_pressed():
	print("clicked")
	if Global.state == "coding":
		teleport_char(initialCharPos)
		robot.rotation_degrees = initialCharRot
		Global.state = "running"
		runButton.text = "RUNNING"
		Global.reset_repeat_times.emit(0)
		await run_code()
		print("done running")
		if Global.state == "running":
			Global.state = "awaitingRestart"
			runButton.text = "RESTART"
	elif Global.state == "awaitingRestart":
		Global.reset_repeat_times.emit(0)
		Global.state = "coding"
		runButton.text = "RUN CODE"
		teleport_char(initialCharPos)
		robot.rotation_degrees = initialCharRot
	elif Global.state == "running":
		tween.kill()
		Global.state = "coding"
		runButton.text = "RUN CODE"
		teleport_char(initialCharPos)
		robot.rotation_degrees = initialCharRot

func next_level():
	mainNode.change_level(nextLevel)

func check_win_condition():
	match name:
		"Level0":
			if local_to_map(robot.position) == Vector2i(9, 1) or local_to_map(robot.position) == Vector2i(10, 1):
				if completed == false: 
					completed = true
					Global.state = "win"
					#next_level()
		"Level1":
			if local_to_map(robot.position) == Vector2i(7, 0) or local_to_map(robot.position) == Vector2i(8, 0):
				if completed == false: 
					completed = true
					Global.state = "win"

func get_char_tile():
	return self.get_cell_tile_data(0,self.local_to_map(robot.position)).get_custom_data("Type")

func get_char_pos():
	return self.local_to_map(robot.position)

func teleport_char(pos : Vector2i):
	robot.position = self.map_to_local(pos)

func move_char(direction : String, steps : int):
	
	var currentTile = get_char_pos()
	var roboRot : int

	if robot.rotation_degrees >= 0:
		roboRot = 3 - round(robot.rotation_degrees / 90)
	else:
		roboRot = int(abs(round(robot.rotation_degrees / 90))-1) % 4
	var neighbors = [TileSet.CELL_NEIGHBOR_LEFT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE ,TileSet.CELL_NEIGHBOR_RIGHT_SIDE , TileSet.CELL_NEIGHBOR_TOP_SIDE]
	#print(int(abs(round(robot.rotation_degrees / 90)))-1)
	
	var neighborCell
	match direction:
		"forward":
			neighborCell = self.get_neighbor_cell(currentTile, neighbors[roboRot])
	
	#print(currentTile)
	#print(neighborCell)
	#print(self.map_to_local(neighborCell))
	#CHECK IF WALL OR ANYTHING ELSE
	var tileData = self.get_cell_tile_data(0, neighborCell)
	if tileData.get_custom_data("Type") == "floor":
		print("moving to floor")
		tween = get_tree().create_tween()
		tween.tween_property(robot, "position", self.map_to_local(neighborCell), 0.5).set_trans(Tween.TRANS_CIRC)
	elif tileData.get_custom_data("Type") == "wall":
		print("Moving into wall")
		var initialPos = robot.position
		var wallPos = self.map_to_local(neighborCell)
		tween = get_tree().create_tween()
		await tween.tween_property(robot, "position", robot.position + (wallPos - robot.position)/2, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).finished
		tween = get_tree().create_tween()
		await tween.tween_property(robot, "position", initialPos, 0.5).set_trans(Tween.TRANS_BOUNCE).finished

func rotate_char(direction : String):
	match direction:
		"Right":
			tween = get_tree().create_tween()
			tween.tween_property(robot, "rotation_degrees", robot.rotation_degrees + 90, 0.5).set_trans(Tween.TRANS_CIRC)
		"Left":
			tween = get_tree().create_tween()
			tween.tween_property(robot, "rotation_degrees", robot.rotation_degrees - 90, 0.5).set_trans(Tween.TRANS_CIRC)

func check_repeat_end_difference_bellow(index):
	var diff = 0
	for i in range(index, commands.get_child_count(), 1):
		if commands.get_child(i).is_in_group("Ghost") == false:
			if commands.get_child(i).commandName == "RepeatTimes":
				diff -= 1
			elif commands.get_child(i).commandName == "RepeatEnd":
				diff += 1
	return diff

func check_repeat_end_difference_above(index):
	var diff = 0
	for i in range(index, -1, -1):
		if commands.get_child(i).is_in_group("Ghost") == false:
			if commands.get_child(i).commandName == "RepeatTimes":
				diff += 1
			elif commands.get_child(i).commandName == "RepeatEnd":
				diff -= 1
	return diff

func check_code_for_errors():
	#check repeat errors
	var error = false
	for code in commands.get_children():
		if code.is_in_group("Command"):
			if code.commandName == "RepeatTimes":
				if check_repeat_end_difference_bellow(code.get_index()) < 0:
					print("Error at index " + str(code.get_index()))
					errorIndex = code.get_index()
					#set the block red
					code.modulate.g = 0
					code.modulate.b = 0
					error = true
					break
	if error == true:
		Global.state = "error"
	elif Global.state != "win":
		Global.state = "coding"
		errorIndex = -1

func set_indent():
	for code in commands.get_children():
		if code.is_in_group("Command") and ghostCode == false:
			var toIndent = check_repeat_end_difference_above(code.get_index())
			if code.is_in_group("Ghost") == false:
				if code.commandName == "RepeatTimes":
					toIndent -= 1
			code.indent = toIndent


func run_code():
	var i = 0
	while i < commands.get_child_count():
		if Global.state == "coding":
			print("BROKE")
			break
		var codeBlock = commands.get_child(i)
		if codeBlock.commandName != "Droppable" and Global.state != "win":
			match codeBlock.commandName:
				"MoveForward":
					move_char("forward", 1)
				"RotateRight":
					rotate_char("Right")
				"RotateLeft":
					rotate_char("Left")
				"RepeatEnd":
					var repeatBlockStart = codeBlock.repeatStart
					print("Repeat amount left" + str(repeatBlockStart.get_node("Background").get_node("RepeatDropDown").repeatAmountLeft))
					if repeatBlockStart.get_node("Background").get_node("RepeatDropDown").repeatAmountLeft > 1:
						repeatBlockStart.get_node("Background").get_node("RepeatDropDown").repeatAmountLeft -= 1
						Global.reset_repeat_times.emit(repeatBlockStart.indent)
						i = repeatBlockStart.get_index()
			print(i)
			#move the arrow
			tween = get_tree().create_tween()
			tween.tween_property(arrow, "global_position", Vector2(arrow.global_position.x, codeBlock.global_position.y+9), 0.1)
			await get_tree().create_timer(Global.ticktime).timeout
			i+=1
		elif Global.state == "win":
			break

func _ready():
	Global.run_button_pressed.connect(run_button_pressed.bind())
	teleport_char(initialCharPos)
	robot.rotation_degrees = initialCharRot
	Global.reload_code_picker.emit()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#check if ghostcode
	ghostCode = false
	for code in commands.get_children():
		if code.is_in_group("Ghost"):
			print("There is ghost code")
			ghostCode = true
			break
	
	check_win_condition()
	if Global.state != "running":
		if ghostCode == false:
			check_code_for_errors()
		set_indent()
	if Global.state == "error":
		runButton.text = "ERROR"
		errorPanel.visible = true
	elif Global.state == "coding":
		runButton.text = "Run"
		errorPanel.visible = false
	#print(Global.state)



#func _on_run_button_pressed():
	#print("clicked")
	#if Global.state == "coding":
		#teleport_char(initialCharPos)
		#Global.state = "running"
		#runButton.text = "RUNNING"
		#Global.reset_repeat_times.emit(0)
		#await run_code()
		#print("done running")
		#if Global.state == "running":
			#Global.state = "awaitingRestart"
			#runButton.text = "RESTART"
	#elif Global.state == "awaitingRestart":
		#Global.reset_repeat_times.emit(0)
		#Global.state = "coding"
		#runButton.text = "RUN CODE"
		#teleport_char(initialCharPos)
		#robot.rotation_degrees = initialCharRot
	#elif Global.state == "running":
		#tween.kill()
		#Global.state = "coding"
		#runButton.text = "RUN CODE"
		#teleport_char(initialCharPos)
		#robot.rotation_degrees = initialCharRot
