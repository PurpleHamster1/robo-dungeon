extends Node2D

@onready var levelNode = $Level
@onready var codingArea = $GUI/Background/VSplitContainer/Lines/VBoxContainer
@onready var codePicker = $GUI/Background/VSplitContainer/Code/CodePicker

var allLevels = {
	"Level0" = preload("res://levels/level_0.tscn"),
	"Level1" = preload("res://levels/level_1.tscn"),
	"Level2" = preload("res://levels/level_2.tscn"),
	"Level3" = preload("res://levels/level_3.tscn"),
	"Level4" = preload("res://levels/level_4.tscn"),
	"Level5" = preload("res://levels/level_5.tscn"),
	"Level6" = preload("res://levels/level_6.tscn")
}

func change_level(levelName):
	if levelNode.get_child(0) != null:
		
		levelNode.get_child(0).queue_free()
		var newLevel = allLevels[levelName].instantiate()
		levelNode.add_child(newLevel)
		
		Global.state = "coding"
		
		#clear coding area
		for obj in codingArea.get_children():
			obj.ghostCode.queue_free()
			obj.queue_free()
		#clear code picker
		for obj in codePicker.get_children():
			obj.ghostCode.queue_free()
			obj.queue_free()
		#load code
		Global.reload_code_picker.emit()
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_run_button_pressed():
	Global.run_button_pressed.emit()


func _on_next_level_pressed():
	change_level(levelNode.get_child(0).nextLevel)
