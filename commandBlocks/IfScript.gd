extends Control
@export var ifEnd : Node


@onready var GUI = $"../../../../../../.."
@onready var ifEnd0 = GUI.find_child("IfEnd", true)
@onready var mainBody = $"../.."
@onready var codingArea = $"../../../../../Lines/VBoxContainer"

@export var deployd = false
@export var endDeployd = false

var indentDebouceFrameCount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	ifEnd = ifEnd0.duplicate(15)
	GUI.add_child.call_deferred(ifEnd)
	ifEnd.visible = false
	ifEnd.ifStart = mainBody


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ifEnd != null:
		if mainBody.ghostCode.visible == true and deployd == false:
			ifEnd.ghostCode.visible = true
			ifEnd.ghostCode.reparent(mainBody.ghostCode.get_parent(), true)
			mainBody.ghostCode.get_parent().move_child(ifEnd.ghostCode, mainBody.ghostCode.get_index()+1)
		elif ifEnd.get_parent().name == "VBoxContainer":
			ifEnd.ghostCode.visible = false
			ifEnd.ghostCode.reparent(mainBody.ghostCode.get_parent(), true)
	
	if mainBody.get_parent().name == "VBoxContainer":
		deployd = true
	
	if deployd == true and mainBody.get_parent().name == "VBoxContainer" and endDeployd == false:
		endDeployd = true
		ifEnd.reparent(mainBody.get_parent(), true)
		mainBody.get_parent().move_child(ifEnd, mainBody.get_index()+1)
		ifEnd.visible = true
	
	#make it so you can't change while code is running
	if Global.state == "running":
		$"../TileDrop".button_mask = 0
		$"../LocationDrop".button_mask = 0
	else:
		$"../TileDrop".button_mask = MOUSE_BUTTON_MASK_LEFT
		$"../LocationDrop".button_mask = MOUSE_BUTTON_MASK_LEFT
	
	#set the repeat end
	if deployd == true and mainBody.get_parent().name == "VBoxContainer" and endDeployd == true and Global.state != "error":
		if indentDebouceFrameCount == 0:
			for i in range(mainBody.get_index(), mainBody.get_parent().get_child_count(), 1):
				if codingArea.get_child(i).is_in_group("Command"):
					if codingArea.get_child(i).commandName == "IfEnd" and codingArea.get_child(i).indent == mainBody.indent:
						ifEnd = codingArea.get_child(i)
						codingArea.get_child(i).ifStart = mainBody
						#mainBody.ifEnd = codingArea.get_child(i)
		else:
			indentDebouceFrameCount -= 1
