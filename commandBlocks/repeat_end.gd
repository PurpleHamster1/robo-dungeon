extends MarginContainer
@export var commandName : String
@export var indent : int = 0
@export var draggable : bool = false
@export var repeatStart : Node

@onready var GUI = $".."
#@onready var marginContainer = $"."
@onready var draggingZone = $"../DraggingZone"
@onready var area2d = $Background/Area2D
@onready var codingArea = $"../Background/VSplitContainer/Lines/VBoxContainer" #GUI.find_child("Background").find_child('VSplitContainer').find_child('Lines').find_child('VBoxContainer')
@onready var ghostCode0 = GUI.find_child("GhostCode", true) #$"../../../../../GhostCode"
@export var ghostCode : Node
@onready var codePicker = $"../Background/VSplitContainer/Code/CodePicker"

var dropZone = null
var offSet
var initialParent
var initialIndex
var frameDebounce = 3

func get_closest_drop():
	var closestDistance = INF
	var closestDrop = null
	for body in area2d.get_overlapping_areas():
		if body.is_in_group("Droppable") and body.get_parent().get_parent() != self:
			if self.position.distance_to(body.position) < closestDistance:
				closestDistance = self.position.distance_to(body.position)
				closestDrop = body
	return closestDrop

# Called when the node enters the scene tree for the first time.
func _ready():
	ghostCode = ghostCode0.duplicate(15)
	GUI.add_child.call_deferred(ghostCode)
	ghostCode.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_theme_constant_override("margin_left", 10 + (indent * 10))
	if draggable == true:
		if Input.is_action_just_pressed('click') and Global.is_dragging == false:
			Global.is_dragging = true
			offSet = get_global_mouse_position() - global_position
			initialIndex = self.get_index()
			#CODE THAT MAKES YOU CRY V
			if self.get_parent().name == "CodePicker":
				initialIndex = codingArea.get_child_count()
			ghostCode.reparent(codingArea, true)
			codingArea.move_child(ghostCode, initialIndex)
			self.reparent(draggingZone, true)
			codePicker.load_code()
			print(ghostCode.get_index())
		if Input.is_action_pressed("click") and Global.is_dragging == true:
			#print("Dragging")
			if offSet:
				global_position = get_global_mouse_position() - offSet
			if ghostCode.visible != true:
				ghostCode.visible = true
			if ghostCode.get_parent() != codingArea:
				ghostCode.reparent(codingArea, true)
			if frameDebounce == 0:
				frameDebounce = 3
				dropZone = get_closest_drop()
				if dropZone != null:
					#print(dropZone.name)
					if dropZone.get_parent().get_parent().get_index() >= repeatStart.get_index():
						if dropZone.is_in_group("AreaUp") and dropZone.get_parent().get_parent().get_parent().name == "VBoxContainer" and dropZone.get_parent().get_parent().get_index() > repeatStart.get_index():
							codingArea.move_child(ghostCode, dropZone.get_parent().get_parent().get_index())
						elif dropZone.is_in_group("AreaDown") and dropZone.get_parent().get_parent().get_parent().name == "VBoxContainer" and dropZone.get_parent().get_parent().get_index() > repeatStart.get_index() + 1:
							codingArea.move_child(ghostCode, dropZone.get_parent().get_parent().get_index()+1)
					else:
						codingArea.move_child(ghostCode, repeatStart.get_index() + 1)
						pass
				else:
					#print("No dropzone")
					#ghostCode.reparent(draggingZone)
					
					pass
			if frameDebounce > 0:
				frameDebounce -= 1
		elif Input.is_action_just_released("click") and Global.is_dragging == true:
			Global.is_dragging = false
			if get_closest_drop() != null:
				reparent(codingArea, true)
				codingArea.move_child(self, ghostCode.get_index())
				draggable = false
				scale = Vector2(1, 1)
			else:
				reparent(codingArea, true)
				codingArea.move_child(self, ghostCode.get_index())
				draggable = false
				scale = Vector2(1, 1)
			ghostCode.reparent(GUI, true)
			ghostCode.visible = false
func _on_background_mouse_entered():
	if Global.is_dragging == false and Global.state != "running":
		draggable = true
		scale = Vector2(1.1, 1.1)

func _on_background_mouse_exited():
	if Global.is_dragging == false:
		draggable = false
		scale = Vector2(1, 1)

func _on_area_2d_area_entered(area):
#	if area.name == "DroppableArea":
#		dropZone = area.get_parent()
#		print("entered", dropZone.name)
	pass

func _on_area_2d_area_exited(area):
#	if area.get_parent() == dropZone:
#		print("Exited", dropZone.name)
#		dropZone = null
	pass
