extends VBoxContainer


@onready var Level = $"../../../../../Level"

var codeTypes = {
	"MoveForward": preload("res://commandBlocks/move_foreward.tscn"),
	"TurnLeft": preload("res://commandBlocks/rotate_left.tscn"),
	"TurnRight": preload("res://commandBlocks/rotate_right.tscn"),
	"RepeatTimes": preload("res://commandBlocks/repeat_times.tscn")
	
}
var codeList = [preload("res://commandBlocks/move_foreward.tscn"), preload("res://commandBlocks/rotate_left.tscn"), preload("res://commandBlocks/rotate_right.tscn")]
var debounce = false

func load_code():
	for c in self.get_children():
			c.ghostCode.queue_free()
			c.queue_free()
	for i in range(Level.get_child(0).commandsAv.size()):
		var code = codeTypes[Level.get_child(0).commandsAv[i]].instantiate()
		add_child(code)
# Called when the node enters the scene tree for the first time.
func _ready():
	load_code()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
