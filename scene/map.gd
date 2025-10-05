extends Node3D

var thismap = true
var GoLeft = true
var nextmap = true
var preGoLeft = true
var level = 0
var swap = true
var preani = "Armature_004|mixamo_com|Layer0"
func clear_maps_except(except_map: Node):
	print("Clear on")
	for child in get_children():
		if child != except_map:
			print(child)
			child.queue_free()

func set_level(x: int):
	level = x

func get_level():
	return level
	
func toggle_swap():
	swap = !swap
	print("swap:", swap)


func _on_timer_timeout() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scene/Scenario/Menu.tscn")
	print("warp")
	pass # Replace with function body.
