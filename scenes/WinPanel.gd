extends Panel

@onready var description = $Text
@onready var codeLines = $"../Background/VSplitContainer/Lines/VBoxContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.state == "win":
		visible = true
	else:
		visible = false
	
	#scrie description
	description.text = "[center] Ai batut nivelul folosind " + str(codeLines.get_child_count()) + " blocuri de cod!"
