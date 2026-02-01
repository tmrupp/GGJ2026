extends MeshInstance3D

var world_min
var world_max

func _ready() -> void:
	var aabb: AABB = global_transform * get_aabb()
	world_min = aabb.position
	world_max = aabb.position + aabb.size

func _random_world_loc ():
	var x = randf_range(world_min.x, world_max.x)
	var z = randf_range(world_min.z, world_max.z)
	return Vector3(x, 0, z)
