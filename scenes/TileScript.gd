extends TileMap

var charPos = [0, 0]

@onready var robot = $Character

func get_char_tile():
	return self.get_cell_tile_data(0,self.local_to_map(robot.position)).get_custom_data("Type")

func _ready():
	print(self.local_to_map(robot.position))
	print(get_char_tile())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
