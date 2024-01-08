extends Node

signal reset_repeat_times(indent)
signal run_button_pressed()
signal reload_code_picker()

var is_dragging = false
var ticktime = 1
var state = "coding"
var current_drag
