extends Panel

@onready var gameSpeedText = $GameSpeed
@onready var slider = $Slider
@onready var level = $"../../Level"
var inX
var inY

# Called when the node enters the scene tree for the first time.
func _ready():
	gameSpeedText.text = str(slider.value) + " x"
	inX = position.x
	inY = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level.get_child(0).currentLevel == 6:
		position.x = inX - 275
	else:
		position.x = inX
	


func _on_slider_drag_ended(value_changed):
	gameSpeedText.text = str(slider.value) + " x"
	Global.gameSpeed = slider.value
	#Engine.time_scale = slider.value
