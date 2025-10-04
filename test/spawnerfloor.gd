extends Node3D

@export var tile_scene: PackedScene        # ลาก FloorTile.tscn มาวาง
@export var tile_length: float = 10.0      # ความยาวของ 1 แผ่น
@export var spawn_distance: int = 20       # ต้องมีแผ่นพื้นยาวแค่ไหนข้างหน้าผู้เล่น
@export var player_path: NodePath          # reference ไปหา Player

var tiles: Array[Node3D] = []
var last_tile_z: float = 0.0
var player: Node3D

func _ready():
	player = get_node(player_path)
	
	# สร้างแผ่นพื้นเริ่มต้น
	for i in range(10):
		_spawn_tile(i * tile_length)

func _process(delta: float) -> void:
	var player_z = player.global_transform.origin.z
	
	# ถ้าผู้เล่นใกล้ถึงแผ่นสุดท้าย → สร้างเพิ่ม
	if player_z + spawn_distance > last_tile_z:
		_spawn_tile(last_tile_z + tile_length)

	# ถ้าแผ่นพื้นอยู่ไกลเกินไปด้านหลัง → ลบออก
	if tiles.size() > 0 and tiles[0].global_transform.origin.z + tile_length < player_z - 10.0:
		var old_tile = tiles.pop_front()
		old_tile.queue_free()

func _spawn_tile(z_pos: float):
	var tile = tile_scene.instantiate() as Node3D
	add_child(tile)
	tile.position = Vector3(0, 0, z_pos)
	tiles.append(tile)
	last_tile_z = z_pos
