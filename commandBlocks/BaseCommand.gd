extends MarginContainer

@export var commandName : String
@export var indent : int = 0
@export var draggable : bool = false

@onready var marginContainer = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	marginContainer.add_theme_constant_override("margin_left", 10 + (indent * 10))

func _on_background_mouse_entered():
	if Global.is_dragging == false:
		draggable = true
		scale = Vector2(1.1, 1.1)

func _on_background_mouse_exited():
	if Global.is_dragging == false:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_2d_area_entered(area):
	if area.name == "DroppableArea":
		var dropZone = area.get_parent()
		print(dropZone.name)
