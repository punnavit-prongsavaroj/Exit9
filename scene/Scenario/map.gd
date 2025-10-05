extends Node3D

var random_map
var TF = RandomNumberGenerator.new()
var map_path
var thismap = true
var GoLeft = true
var manager: Node = null
var nextmap = true
var animationkumron

func _ready():
	manager = get_parent() 

func load_next_map(): #สร้างแมพต่อไป
	TF.randomize()
	
	
	# สุ่มแผนที่ว่าแมพต่อไปจะเป็นทางที่ถูกหรือผิด
	if TF.randi_range(0, 1) == 0: #เมื่อถูกสร้างแมพ1
		thismap = nextmap
		nextmap = true
		map_path = "res://scene/Scenario/1.tscn"
		animationkumron = "Armature_004|mixamo_com|Layer0"
	else: #เมื่อผิดสร้างแมพอื่น
		nextmap = false
		random_map = TF.randi_range(2, 10)
		map_path = "res://scene/Scenario/%d.tscn" % random_map 
		random_map = TF.randi_range(1, 4)
		if random_map == 1:
			animationkumron = "Armature_001|mixamo_com|Layer0"
		elif random_map == 2:
			animationkumron = "Armature_002|mixamo_com|Layer0"
		elif random_map == 3:
			animationkumron = "Armature_003|mixamo_com|Layer0"
		elif random_map == 4:
			animationkumron = "Armature|mixamo_com|Layer0"
	print(random_map)
	print("thismap:", thismap)
	print("nextmap:", nextmap)
	print("GoLeft:", GoLeft)
	print("map_path:", map_path)
	manager.toggle_swap()
	print("swap:", manager.swap)
	
	$teacherkumronfull.animationset(animationkumron)
	
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

		if !manager.swap:
			if thismap:
				map_scene.position.z = position.z - 51.18
			else:
				map_scene.position.z = position.z + 60.045
		else:
			if thismap:
				map_scene.position.z = position.z - 60.045
			else:
				map_scene.position.z = position.z + 51.18
				
	

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

	if GoLeft and thismap:
		if manager and manager.has_method("get_level") and manager.has_method("set_level"):
			manager.set_level(manager.get_level() + 1)
			if manager.get_level() == 5:
				print("win!")
		else:
			print("manager missing level functions")
		print("Go Next",manager.get_level())
	elif GoLeft and !thismap:
		print("gameover")
	elif !GoLeft and !thismap:
		if manager and manager.has_method("get_level") and manager.has_method("set_level"):
			manager.set_level(manager.get_level() + 1)
			if manager.get_level() == 5:
				print("win!")
		else:
			print("manager missing level functions")
		GoLeft = !GoLeft
		print("Go Back",manager.get_level())
	elif !GoLeft and thismap:
		print("gameover")
	
func _on_back_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	$create.monitoring = true
	if !GoLeft and thismap:
		if manager and manager.has_method("get_level") and manager.has_method("set_level"):
			manager.set_level(manager.get_level() + 1)
			if manager.get_level() == 5:
				print("win!")
		else:
			print("manager missing level functions")
		print("Go Next",manager.get_level())
		
	if GoLeft and !thismap:
		if manager and manager.has_method("get_level") and manager.has_method("set_level"):
			manager.set_level(manager.get_level() + 1)
			if manager.get_level() == 5:
				print("win!")
		else:
			print("manager missing level functions")
		GoLeft = !GoLeft
		print("Go Back",manager.get_level())
		
	elif GoLeft and thismap:
		print("game over")
	elif !GoLeft and !thismap:
		print("game over")


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
