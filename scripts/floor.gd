extends Node3D

var world_min
var world_max

@onready var default_3d_map_rid: RID = get_world_3d().get_navigation_map()

func _random_world_loc ():
	return NavigationServer3D.map_get_random_point(default_3d_map_rid, 1, true)
