extends MarginContainer

@export var commandName : String
@export var indent : int = 0
@export var draggable : bool = false

@onready var marginContainer = $"."
@onready var draggingZone = $"../../../../../DraggingZone"
@onready var area2d = $Background/Area2D
@onready var codingArea = $".."
@onready var ghostCode = $"../../../../../GhostCode"

var dropZone = null
var offSet
var initialParent
var initialIndex
var frameDebounce = 5

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
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	marginContainer.add_theme_constant_override("margin_left", 10 + (indent * 10))
	if draggable == true:
		if Input.is_action_just_pressed('click') and Global.is_dragging == false:
			Global.is_dragging = true
			offSet = get_global_mouse_position() - global_position
			initialIndex = self.get_index()
			ghostCode.reparent(codingArea, true)
			codingArea.move_child(ghostCode, initialIndex)
			self.reparent(draggingZone, true)
			print(ghostCode.get_index())
		if Input.is_action_pressed("click") and Global.is_dragging == true:
			#print("Dragging")
			global_position = get_global_mouse_position() - offSet
			if ghostCode.visible != true:
				ghostCode.visible = true
			if ghostCode.get_parent() != codingArea:
				ghostCode.reparent(codingArea, true)
			if frameDebounce == 0:
				frameDebounce = 5
				dropZone = get_closest_drop()
				if dropZone != null:
					#print(dropZone.name)
					if dropZone.is_in_group("AreaUp"):
						codingArea.move_child(ghostCode, dropZone.get_parent().get_parent().get_index())
					elif dropZone.is_in_group("AreaDown"):
						codingArea.move_child(ghostCode, dropZone.get_parent().get_parent().get_index()+1)
				else:
					#print("No dropzone")
					#ghostCode.reparent(draggingZone)
					pass
			if frameDebounce > 0:
				frameDebounce -= 1
		elif Input.is_action_just_released("click") and Global.is_dragging == true:
			Global.is_dragging = false
			if get_closest_drop() != null:
				if get_closest_drop().name == "DeathArea":
					queue_free()
			else:
				reparent(codingArea, true)
				codingArea.move_child(self, ghostCode.get_index())
				draggable = false
				scale = Vector2(1, 1)
			ghostCode.reparent(draggingZone, true)
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
