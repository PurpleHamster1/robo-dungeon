extends Button

@export var level:int
@export var levelName:String

@onready var overlay = $LockedOverlay
@onready var mainNode = $"../../.."
@onready var mainMenu = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.highestLevel < level:
		#overlay.visible = true
		#overlay.mouse_filter = MOUSE_FILTER_STOP
		pass
	else:
		overlay.visible = false
		overlay.mouse_filter = MOUSE_FILTER_IGNORE


func _on_pressed():
	mainNode.change_level(levelName)
	mainMenu.visible = false
