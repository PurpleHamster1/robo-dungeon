extends OptionButton

@export var repeatAmount : int
@export var repeatEnd : Node


@onready var GUI = $"../../../../../../.."
@onready var repeatEnd0 = GUI.find_child("RepeatEnd", true)
@onready var mainBody = $"../.."
@onready var codingArea = $"../../../../../Lines/VBoxContainer"

@export var deployd = false
@export var endDeployd = false

var indentDebouceFrameCount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	repeatEnd = repeatEnd0.duplicate(15)
	GUI.add_child.call_deferred(repeatEnd)
	repeatEnd.visible = false
	repeatEnd.repeatStart = mainBody
	selected = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mainBody.ghostCode.visible == true and deployd == false:
		repeatEnd.ghostCode.visible = true
		repeatEnd.ghostCode.reparent(mainBody.ghostCode.get_parent(), true)
		mainBody.ghostCode.get_parent().move_child(repeatEnd.ghostCode, mainBody.ghostCode.get_index()+1)
	elif repeatEnd.get_parent().name == "VBoxContainer":
		repeatEnd.ghostCode.visible = false
		repeatEnd.ghostCode.reparent(mainBody.ghostCode.get_parent(), true)
	
	if mainBody.get_parent().name == "VBoxContainer":
		deployd = true
	
	if deployd == true and mainBody.get_parent().name == "VBoxContainer" and endDeployd == false:
		endDeployd = true
		repeatEnd.reparent(mainBody.get_parent(), true)
		mainBody.get_parent().move_child(repeatEnd, mainBody.get_index()+1)
		repeatEnd.visible = true
	
	#set the repeat end
	if deployd == true and mainBody.get_parent().name == "VBoxContainer" and endDeployd == true and Global.state != "error":
		if indentDebouceFrameCount == 0:
			for i in range(mainBody.get_index(), mainBody.get_parent().get_child_count(), 1):
				if codingArea.get_child(i).is_in_group("Command"):
					if codingArea.get_child(i).commandName == "RepeatEnd" and codingArea.get_child(i).indent == mainBody.indent:
						repeatEnd = codingArea.get_child(i)
		else:
			indentDebouceFrameCount -= 1


func _on_item_selected(index):
	repeatAmount = index + 2
