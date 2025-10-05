extends Node3D

var level = 0
var swap = true
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
