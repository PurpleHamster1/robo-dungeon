extends Panel

@onready var crtButton = $Options/CRT/CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_button_pressed():
	visible = !visible


func _on_check_button_pressed():
	Global.CRT = crtButton.button_pressed
	Global.changed_setting.emit()
