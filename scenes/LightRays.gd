extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		var tween = get_tree().create_tween()
		await tween.tween_property(self, "modulate:a", 0.5, 2).finished
		tween = get_tree().create_tween()
		await tween.tween_property(self, "modulate:a", 1, 2).finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
