extends TextureButton
@onready var level = $"../../Level"
var inX

# Called when the node enters the scene tree for the first time.
func _ready():
	inX = position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level.get_child(0).currentLevel == 6:
		position.x = inX - 275
	else:
		position.x = inX
	
	#if Global.state == "running":
		#disabled = true
	#else:
		#disabled = false
	pass


func _on_pressed():
	disabled = true
	await get_tree().create_timer(1).timeout
	disabled = false
