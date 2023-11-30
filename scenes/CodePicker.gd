extends VBoxContainer


var codeTypes = {
	"MoveForward": preload("res://commandBlocks/move_foreward.tscn"),
	"TurnLeft": preload("res://commandBlocks/rotate_left.tscn"),
	"TurnRight": preload("res://commandBlocks/rotate_right.tscn")
	
}
var codeList = [preload("res://commandBlocks/move_foreward.tscn"), preload("res://commandBlocks/rotate_left.tscn"), preload("res://commandBlocks/rotate_right.tscn")]
var debounce = false

func load_code():
	for c in self.get_children():
			c.ghostCode.queue_free()
			c.queue_free()
	for i in range(codeList.size()):
		var code = codeList[i].instantiate()
		add_child(code)
# Called when the node enters the scene tree for the first time.
func _ready():
	load_code()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
