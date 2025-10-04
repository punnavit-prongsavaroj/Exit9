extends Node3D

var random_map
var TF = RandomNumberGenerator.new()
var map_path
var check = true
var GoLeft = true
var manager: Node = null

func _ready():
	manager = get_parent()  # ปลอดภัยกว่า get_parent() ตอนประกาศตัวแปร

func load_next_map():
	TF.randomize()
	
	# สุ่มแผนที่
	if TF.randi_range(0, 1) == 0:
		check = true
		map_path = "res://scene/Scenario/1.tscn"
	else:
		check = false
		random_map = TF.randi_range(2, 10)
		map_path = "res://scene/Scenario/%d.tscn" % random_map 
	
	print(random_map)
	print("check:", check)
	print("GoLeft:", GoLeft)
	print("map_path:", map_path)
	
	# ตรวจสอบว่าไฟล์มีอยู่จริงไหม
	if not FileAccess.file_exists(map_path):
		print("No more maps!")
		return
	
	var map_scene = load(map_path).instantiate()
	
	# เพิ่ม scene เข้า parent เดิม (แทนที่จะใช้ $"..")
	if manager:
		manager.add_child(map_scene)
	else:
		print("No manager found! adding to self")
		add_child(map_scene)
	
	# กำหนดตำแหน่ง
	if map_scene is Node3D:
		map_scene.rotation.y = rotation.y + deg_to_rad(180)
		map_scene.position.x = position.x * -1

		if GoLeft:
			if check:
				map_scene.position.z = position.z - 51.18
			else:
				map_scene.position.z = position.z + 60.045
		else:
			if check:
				map_scene.position.z = position.z + 60.045
			else:
				map_scene.position.z = position.z - 51.18


func _on_create_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	print("player enter")
	
	$next.monitoring = true
	$back.monitoring = true
	$create.monitoring = false

	if manager and manager.has_method("clear_maps_except"):
		print("manager have, clearing old maps...")
		manager.clear_maps_except(self)
	else:
		print("manager missing or has no clear_maps_except()")

	load_next_map()


func _on_next_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	$create.monitoring = true

	if GoLeft and check:
		GoLeft = !GoLeft
		if manager and manager.has_method("get_level") and manager.has_method("set_level"):
			manager.set_level(manager.get_level() + 1)
			if manager.get_level() == 5:
				print("win!")
		else:
			print("manager missing level functions")
	elif GoLeft and !check:
		print("gameover")


func _on_back_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	$create.monitoring = true

	if GoLeft and !check:
		print("back: next level?")
	elif GoLeft and check:
		print("back: game over")


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
