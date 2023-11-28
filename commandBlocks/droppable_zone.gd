extends Panel

@export var commandName : String
@export var direction : String

func _ready():
	#modulate.a = 0
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visible = Global.is_dragging
	pass
