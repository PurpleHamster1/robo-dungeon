extends ColorRect


func change_visibility():
	visible = Global.CRT

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.changed_setting.connect(change_visibility.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
