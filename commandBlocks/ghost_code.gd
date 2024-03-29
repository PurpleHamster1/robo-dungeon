extends MarginContainer

@export var indent : int


func check_repeat_end_difference_above(index):
	var diff = 0
	var commands = get_parent()
	if commands.name == "VBoxContainer":
		for i in range(index, -1, -1):
			if commands.get_child(i).is_in_group("Ghost") == false:
				if commands.get_child(i).commandName == "RepeatTimes" or commands.get_child(i).commandName == "If":
					diff += 1
				elif commands.get_child(i).commandName == "RepeatEnd" or commands.get_child(i).commandName == "IfEnd":
					diff -= 1
	return diff

#func get_indent():
	#var commands = get_parent()
	#if commands.name == "VBoxContainer":
		#for code in commands.get_children():
			#if code.is_in_group("Command"):
				#var toIndent = check_repeat_end_difference_above(code.get_index())
				#if code.is_in_group("Ghost") == false:
					#if code.commandName == "RepeatTimes":
						#toIndent -= 1
				#code.indent = toIndent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_theme_constant_override("margin_left", 10 + (indent * 30))
	indent = check_repeat_end_difference_above(get_index())
	#if get_parent().name == "VBoxContainer":
		#if get_index() + 1 <= get_parent().get_child_count():
			#var nodeUnder = get_parent().get_child(get_index()+1)
			#if nodeUnder != null:
				#if nodeUnder.is_in_group("Ghost") == false:
					#if nodeUnder.commandName == "repeatEnd":
						#indent = nodeUnder.indent + 1
				#else:
					#indent = nodeUnder.indent
