extends Control

@onready var buttonsContainer = $List/VBoxContainer
@onready var descContainer = $Desc


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in buttonsContainer.get_children():
		node.pressed.connect(changeDesc.bind(node.name))
		

func changeDesc(node):
	for v in descContainer.get_children():
		v.visible = false
	descContainer.find_child(node).visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	visible = false
