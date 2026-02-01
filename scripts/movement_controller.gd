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


func set_movement_target(target_position: Vector3):
	await get_tree().physics_frame

	var start_position: Vector3 = conv(position)
	target_position = conv(target_position)

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

	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	
	get_random_walk()
	
	

var max_range = 10.0
var min_range = 3.0
var circuit_index = 0
var random_look
func get_random_walk():
	var v : Vector3
	var vn : Vector3
	random_look = world_floor._random_world_loc()
	for i in range(randi_range(1, 1)):
		if circuit.is_empty():
			vn = world_floor._random_world_loc()
			
		else:
			var t = 2*PI*randf()
			var r = randf_range(min_range, max_range)
			vn = v+Vector3(r*cos(t), 0, r*sin(t))
		circuit.append(vn)
		v = vn
		
	print("circuit=", circuit)
var d = 0
var done = false

func _final_turn():
	var org = conv(global_transform.origin)
	while global_transform.basis.z.dot((random_look - org).normalized()) > -.99:
		await get_tree().create_timer(1.0/60.0).timeout
		var target_direction: Vector3 = (random_look - org).normalized()
		var target_rotation: Basis = Basis.looking_at(target_direction, Vector3.UP)
		basis = basis.slerp(target_rotation, turn_speed * 1/60)
			
func _physics_process(delta):
	var org = conv(global_transform.origin)
	
	if current_path.is_empty() and not done:
		set_movement_target(circuit[circuit_index])
		circuit_index = (circuit_index + 1) % circuit.size()
		return
		
	movement_delta = movement_speed * delta

	if org.distance_to(current_path_point) <= path_point_margin:
		current_path_index += 1
		d = 0
		if current_path_index >= current_path.size():
			current_path = []
			current_path_index = 0
			current_path_point = org
			if circuit.size() == 1:
				if not done: 	
					_final_turn()
				done = true
			return

	current_path_point = current_path[current_path_index]

	if global_transform.basis.z.dot((current_path_point - org).normalized()) > -0.99:
		var target_direction: Vector3 = (current_path_point - org).normalized()
		var target_rotation: Basis = Basis.looking_at(target_direction, Vector3.UP)
		basis = basis.slerp(target_rotation, turn_speed * delta)
	else:
		var new_velocity: Vector3 = org.direction_to(current_path_point) * movement_delta
		move_and_keep_height(org.move_toward(org + new_velocity, movement_delta))
		d += delta
