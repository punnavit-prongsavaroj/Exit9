extends Node3D

var random_map
var TF = RandomNumberGenerator.new()
var map_path

var manager: Node = null
var animationkumron

func _ready():
	manager = get_parent() 

func load_next_map(): #สร้างแมพต่อไป
	TF.randomize()
	
	manager.thismap = manager.nextmap
	# สุ่มแผนที่ว่าแมพต่อไปจะเป็นทางที่ถูกหรือผิด
	if TF.randi_range(0, 4) == 0: #เมื่อถูกสร้างแมพ1
		print(TF)
		manager.nextmap = true
		map_path = "res://scene/Scenario/1.tscn"
		animationkumron = "Armature_004|mixamo_com|Layer0"
	else: #เมื่อผิดสร้างแมพอื่น
		manager.nextmap = false
		manager.preGoLeft = manager.GoLeft
		manager.GoLeft = !manager.GoLeft
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

	manager.toggle_swap()
	print("swap:", manager.swap)
	$teacherkumronfull.animationset(manager.preani)
	manager.preani = animationkumron
	
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
		if manager.preGoLeft :
			if !manager.swap:
				if manager.thismap:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z - 51.18
				else:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z - 51.18
			elif manager.swap:
				if manager.thismap:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z - 60.045
				else:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z + 51.18
		else :
			if !manager.swap:
				if manager.thismap:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z + 60.045
				else:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z - 51.18
			elif manager.swap:
				if manager.thismap:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z + 60.045
				else:
					print(random_map)
					print("thismap:", manager.thismap)
					print("nextmap:", manager.nextmap)
					print("GoLeft:", manager.GoLeft)
					print(manager.preGoLeft)
					print("map_path:", map_path)
					map_scene.position.z = position.z + 51.18
	

func _on_create_body_entered(body: Node3D) -> void:
	
	if not body.is_in_group("player"):
		return
	print("player enter")
	
	$next.monitoring = true
	$back.monitoring = true
	$create.queue_free()

	if manager and manager.has_method("clear_maps_except"):
		print("manager have, clearing old maps...")
		manager.clear_maps_except(self)
	else:
		print("manager missing or has no clear_maps_except()")
	manager.level +=1
	if manager.level == 5:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scene/Scenario/win.tscn")
	load_next_map()


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
