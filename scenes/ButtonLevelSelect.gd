extends Button

@onready var settings = $".."
@onready var mainMenu = $"../../../MainMenu"
@onready var levelSelect = $"../../../MainMenu/LevelSelect"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	settings.visible = false
	mainMenu.visible = true
	levelSelect.visible = true
