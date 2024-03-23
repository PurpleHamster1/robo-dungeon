extends Panel

var still_dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_global_mouse_position().x < 950:
		visible = Global.is_dragging
	else:
		visible = false
