@tool
extends Node3D

@onready var models = [$Clown1, $Clown2]
@onready var animation_players = [$Clown1/ClownEnemyTall/AnimationPlayer, $Clown2/CLOWNSHORTMaterial/AnimationPlayer]
@export var clown_model_index = -1

const color_to_index = {
	Color.RED: 0,
	Color.BLUE: 1,
	Color.YELLOW: 2
}

static var clown_materials = []

func _ready() -> void:
	animation_players[0].set_blend_time("walk", "IDLE", 0.25)
	animation_players[0].set_blend_time("IDLE", "walk", 0.2)
	animation_players[1].set_blend_time("walk", "Idle", 0.25)
	animation_players[1].set_blend_time("Idle", "walk", 0.2)
	set_model()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_model()

func set_model():
	if models == null:
		models = [$Clown1, $Clown2]
	if clown_model_index >= 0 and clown_model_index < len(models):
		for model in models:
			model.hide()
			model.get_node("VisionCone/Area3D").monitoring = false
		models[clown_model_index].show()
		models[clown_model_index].get_node("VisionCone/Area3D").monitoring = true

func set_animation(animation_name : String):
	if clown_model_index == 0:
		if animation_name == "walk":
			animation_players[0].play("walk")
		elif animation_name == "idle":
			animation_players[0].play("IDLE")
	
	elif clown_model_index == 1:
		if animation_name == "walk":
			animation_players[1].play("walk")
		elif animation_name == "idle":
			animation_players[1].play("Idle")

func set_animation_speed_scale(value : float):
	animation_players[clown_model_index].speed_scale = value

func set_color(color : Color):
	if models == null:
		models = [$Clown1, $Clown2]
	if len(clown_materials) == 0:
		setup_clown_materials()
	
	for model in models:
		model.get_node("VisionCone/ConeMesh").material_index = color_to_index[color]
	
	var mesh_instances : Array[MeshInstance3D] = [$Clown1/ClownEnemyTall/rig/Skeleton3D/ClownTall, $Clown2/CLOWNSHORTMaterial/rig/Skeleton3D/Torus_001]
	if color == Color.RED:
		mesh_instances[0].set_surface_override_material(0, clown_materials[0])
		mesh_instances[0].set_surface_override_material(1, clown_materials[3])

		mesh_instances[1].set_surface_override_material(1, clown_materials[0])
		mesh_instances[1].set_surface_override_material(2, clown_materials[3])
	elif color == Color.BLUE:
		mesh_instances[0].set_surface_override_material(0, clown_materials[1])
		mesh_instances[0].set_surface_override_material(1, clown_materials[4])

		mesh_instances[1].set_surface_override_material(1, clown_materials[1])
		mesh_instances[1].set_surface_override_material(2, clown_materials[4])
	elif color == Color.YELLOW:
		mesh_instances[0].set_surface_override_material(0, clown_materials[2])
		mesh_instances[0].set_surface_override_material(1, clown_materials[5])

		mesh_instances[1].set_surface_override_material(1, clown_materials[2])
		mesh_instances[1].set_surface_override_material(2, clown_materials[5])
	
func setup_clown_materials():
	clown_materials = []
	var colors = [Color.RED, Color.BLUE, Color.YELLOW, Color.ORANGE_RED, Color.CYAN, Color.YELLOW_GREEN]
	for color in colors:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = color
		clown_materials.append(mat)
