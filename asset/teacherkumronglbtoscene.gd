extends Node3D

@export var speed: float = 100.0

func _process(delta: float) -> void:
	# เดินไปข้างหน้าตามทิศที่ node หันอยู่
	translate(Vector3.BACK * speed * delta)

func animationset(x:String):
	$AnimationPlayer.play(x)
