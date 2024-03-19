extends Panel

@export var level : int = 0

var current = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if level < Global.highestLevel:
		visible = false
	else:
		visible = true
	for node in get_children():
		if node.find_child("ButtonNext"):
			node.find_child("ButtonNext").pressed.connect(_on_pressed_next)

func _on_pressed_next():
	get_child(current).visible = false
	current += 1
	if current < get_child_count():
		get_child(current).visible = true
	print("yea")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
