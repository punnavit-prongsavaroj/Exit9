extends Node3D



func _on_button_pressed() -> void:
	var start = preload("res://scene/main.tscn")
	get_tree().change_scene_to_packed(start)
