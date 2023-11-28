extends TileMap

@export var initialCharPos : Vector2i
@export var initialCharRot : int

@onready var robot = $Character
@onready var commands = $"../GUI/Background/VSplitContainer/Lines/VBoxContainer"
@onready var runButton = $"../GUI/RunButton"

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
	print(int(abs(round(robot.rotation_degrees / 90)))-1)
	
	var neighborCell
	match direction:
		"forward":
			neighborCell = self.get_neighbor_cell(currentTile, neighbors[roboRot])
	
	#print(currentTile)
	#print(neighborCell)
	#print(self.map_to_local(neighborCell))
	robot.position = self.map_to_local(neighborCell)

func rotate_char(direction : String):
	match direction:
		"Right":
			robot.rotation_degrees += 90
		"Left":
			robot.rotation_degrees -= 90

func run_code():
	for i in range(commands.get_child_count()):
		var codeBlock = commands.get_child(i)
		if codeBlock.commandName != "Droppable":
			match codeBlock.commandName:
				"MoveForward":
					move_char("forward", 1)
				"RotateRight":
					rotate_char("Right")
				"RotateLeft":
					rotate_char("Left")
			await get_tree().create_timer(Global.ticktime).timeout

func _ready():
	teleport_char(initialCharPos)
	robot.rotation_degrees = initialCharRot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_run_button_pressed():
	if Global.state == "coding":
		Global.state = "running"
		runButton.text = "RUNNING"
		await run_code()
		print("done running")
		Global.state = "awaitingRestart"
		runButton.text = "RESTART"
	elif Global.state == "awaitingRestart":
		Global.state = "coding"
		runButton.text = "RUN CODE"
		teleport_char(initialCharPos)
		robot.rotation_degrees = initialCharRot
