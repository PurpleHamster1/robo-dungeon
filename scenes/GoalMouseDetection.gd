extends Panel

@onready var goalDescription = $GoalDescription

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	goalDescription.visible = true


func _on_mouse_exited():
	goalDescription.visible = false
