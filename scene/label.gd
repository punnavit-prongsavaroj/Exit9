extends Label
func _process(delta: float) -> void:
	set_text("Level "+str($"../Map".level))
