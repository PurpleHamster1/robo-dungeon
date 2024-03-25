extends Sprite2D

@onready var levels = $"../Maps"
var oldHover = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		await get_tree().create_timer(0.5).timeout
		if Global.levelHover > 0:
			levels.get_child(Global.levelHover-1).visible = !levels.get_child(Global.levelHover-1).visible
		else:
			await get_tree().create_timer(0.2).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.levelHover != oldHover:
		levels.get_child(oldHover-1).visible = false
		if Global.levelHover != 0:
			levels.get_child(Global.levelHover-1).visible = true
	oldHover = Global.levelHover
