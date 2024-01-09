extends Panel

@onready var gameSpeedText = $GameSpeed
@onready var slider = $Slider

# Called when the node enters the scene tree for the first time.
func _ready():
	gameSpeedText.text = str(slider.value) + " x"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_slider_drag_ended(value_changed):
	gameSpeedText.text = str(slider.value) + " x"
	Engine.time_scale = slider.value
