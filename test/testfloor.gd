extends StaticBody3D

@export var nextroom = preload("res://test/testfloor.tscn")


var isenter

func _ready() -> void:
	isenter = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !isenter:
		createroom()
		isenter = true
		print("test1")
		
func createroom():
	var next = nextroom.instantiate()
	next.position.z = $".".position.z + -32
	get_parent().add_child(next)
	print(get_parent())


func _on_del_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
