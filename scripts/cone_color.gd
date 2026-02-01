@tool
extends MeshInstance3D

static var material_array = [
	preload("res://resources/translucent_vision_cone_1.tres"),
	preload("res://resources/translucent_vision_cone_2.tres"),
	preload("res://resources/translucent_vision_cone_3.tres")
]
@export var material_index : int = -1
var real_mat_ind = -2

func _ready() -> void:
	set_mat()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_mat()

func set_mat():
	if material_index >= 0 && material_index < len(material_array) and real_mat_ind != material_index:
		print("real_mat_ind=", real_mat_ind, " after material_index=", material_index, " rid=", self)
		real_mat_ind = material_index
		mesh.surface_set_material(0, material_array[material_index])
