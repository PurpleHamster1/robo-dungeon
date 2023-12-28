extends Node2D

@export var rot : String = "Front"

var BodyTextures = [preload("res://assets/robot/BodyDown.PNG"), preload("res://assets/robot/BodyLeft.PNG")]
var HeadTextures = [preload("res://assets/robot/HeadDown.PNG"), preload("res://assets/robot/HeadLeft.PNG")]
var LegsTextures = [preload("res://assets/robot/LegsDown.PNG"), preload("res://assets/robot/LegsLeft.PNG")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var textureIndex
	if rot == "Front":
		textureIndex = 0
	else: textureIndex = 1
	$Legs.texture = LegsTextures[textureIndex]
	$Body.texture = BodyTextures[textureIndex]
	$Head.texture = HeadTextures[textureIndex]
