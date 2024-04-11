extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Global.state == "running":
		#disabled = true
	#else:
		#disabled = false
	pass


func _on_pressed():
	disabled = true
	await get_tree().create_timer(1).timeout
	disabled = false
