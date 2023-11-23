extends TileMap

var charPos = [0, 0]

@onready var robot = $Character
@onready var commands = $"../GUI/Background/VSplitContainer/Lines/VBoxContainer"

func get_char_tile():
	return self.get_cell_tile_data(0,self.local_to_map(robot.position)).get_custom_data("Type")

func get_char_pos():
	return self.local_to_map(robot.position)

func move_char(direction : String, steps : int):
	var currentTile = get_char_pos()
	var roboRot : int = 4 - floor(robot.rotation_degrees / 90)
	print(roboRot)
	var neighbors = [TileSet.CELL_NEIGHBOR_TOP_SIDE, TileSet.CELL_NEIGHBOR_LEFT_SIDE, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE, TileSet.CELL_NEIGHBOR_RIGHT_SIDE]
	var neighborCell
	match direction:
		"forward":
			neighborCell = self.get_neighbor_cell(currentTile, neighbors[roboRot])
	
	print(currentTile)
	print(neighborCell)
	print(self.map_to_local(neighborCell))
	robot.position = self.map_to_local(neighborCell)

func run_code():
	for i in range(commands.get_child_count()):
		var codeBlock = commands.get_child(i)
		if codeBlock.name != "Droppable":
			match codeBlock.name:
				"MoveForward":
					move_char("forward", 1)
				
			await get_tree().create_timer(Global.ticktime).timeout

func _ready():
	#print(self.local_to_map(robot.position))
	#print(get_char_tile())
	charPos = get_char_pos()
	#print(charPos)
	await get_tree().create_timer(Global.ticktime).timeout
	move_char("forward", 1)
	await get_tree().create_timer(Global.ticktime).timeout
	move_char("forward", 1)
	await get_tree().create_timer(Global.ticktime).timeout
	move_char("forward", 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
