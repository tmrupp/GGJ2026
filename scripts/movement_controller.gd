extends Node3D

@onready var default_3d_map_rid: RID = get_world_3d().get_navigation_map()

var movement_speed: float = 4.0
var movement_delta: float
var path_point_margin: float = 0.5

var turn_speed: float = 1.5

var current_path_index: int = 0
var current_path_point: Vector3
var current_path: PackedVector3Array

var circuit: Array

@onready var world_floor = $"../NavigationRegion3D/Floor"
var world_min
var world_max


func set_movement_target(target_position: Vector3):
	await get_tree().physics_frame

	var start_position: Vector3 = conv(position)
	target_position = conv(target_position)
	
	print("default_3d_map_rid=", default_3d_map_rid)

	current_path = NavigationServer3D.map_get_path(
		default_3d_map_rid,
		start_position,
		target_position,
		false
	)

	if not current_path.is_empty():
		current_path_index = 0
		current_path_point = current_path[0]

func conv(v):
	return NavigationServer3D.map_get_closest_point(
		default_3d_map_rid,
		v
	)
	
func move_and_keep_height (v):
	position = Vector3(v.x, position.y, v.z)

func _ready() -> void:
	var aabb: AABB = world_floor.global_transform * world_floor.get_aabb()
	world_min = aabb.position
	world_max = aabb.position + aabb.size
	
	get_random_walk()
	
	print("Local Min Position: ", world_min)
	print("Local Max Position: ", world_max)
	
func _random_world_loc ():
	var x = randf_range(world_min.x, world_max.x)
	var z = randf_range(world_min.z, world_max.z)
	return Vector3(x, 0, z)
	

var max_range = 10.0
var min_range = 3.0
var circuit_index = 0
var random_look
func get_random_walk():
	var v : Vector3
	var vn : Vector3
	random_look = _random_world_loc()
	for i in range(randi_range(1, 4)):
		if circuit.is_empty():
			#var x = randf_range(world_min.x, world_max.x)
			#var z = randf_range(world_min.z, world_max.z)
			#vn = Vector3(x, 0, z)
			vn = Vector3(position.x, 0, position.z)
			
		else:
			var t = 2*PI*randf()
			var r = randf_range(min_range, max_range)
			print("r=", r, " v=", v)
			vn = v+Vector3(r*cos(t), 0, r*sin(t))
		circuit.append(vn)
		v = vn
			
func _physics_process(delta):
	
	var org = conv(global_transform.origin)
	if circuit.size() == 1:
		print("static clown, random_look=", random_look)
		look_at((random_look), Vector3.UP)
		return
	
	if current_path.is_empty():
		print("circuit=", circuit, " circuit_index=", circuit_index)
		set_movement_target(circuit[circuit_index])
		circuit_index = (circuit_index + 1) % circuit.size()
		return
		

	movement_delta = movement_speed * delta

	if org.distance_to(current_path_point) <= path_point_margin:
		current_path_index += 1
		if current_path_index >= current_path.size():
			current_path = []
			current_path_index = 0
			current_path_point = org
			return

	current_path_point = current_path[current_path_index]

	if abs(global_transform.basis.z.dot((current_path_point - org).normalized())) < 0.99:
		var target_direction: Vector3 = (current_path_point - org).normalized()
		var target_rotation: Basis = Basis.looking_at(target_direction, Vector3.UP)
		basis = basis.slerp(target_rotation, turn_speed * delta)
	else:
		var new_velocity: Vector3 = org.direction_to(current_path_point) * movement_delta
		move_and_keep_height(org.move_toward(org + new_velocity, movement_delta))
