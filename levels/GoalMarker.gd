extends Sprite2D

var rng = RandomNumberGenerator.new()
var tween
var count = 0

@onready var markerRange1 = $"../../MarkerSpawn1"
@onready var markerRange2 = $"../../MarkerSpawn2"
@onready var markerFinal = $"../../MarkerFinal"
@onready var cross = $Crosshair2

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = rng.randf_range(markerRange1.global_position.x, markerRange2.global_position.x)
	global_position.y = rng.randf_range(markerRange1.global_position.y, markerRange2.global_position.y)
	rotation_degrees = rng.randi_range(90, 270)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rotation_degrees += 4
	pass


func _on_visibility_changed():
	count+=1
	if visible == false:
		cross.modulate.a = 0
		global_position.x = rng.randf_range(markerRange1.global_position.x, markerRange2.global_position.x)
		global_position.y = rng.randf_range(markerRange1.global_position.y, markerRange2.global_position.y)
		rotation_degrees = rng.randi_range(90, 270)
		if tween != null:
			tween.kill()
	elif visible == true:
		var oldCount = count
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", markerFinal.global_position, 0.4)
		await tween.parallel().tween_property(self, "rotation_degrees", markerFinal.rotation_degrees, 0.4).finished
		if oldCount == count:
			tween = get_tree().create_tween()
			tween.tween_property(cross, "modulate:a", 1, 1)
		
