@tool
extends Node3D

@onready var models = [$Clown1, $Clown2]
@onready var animation_players = [$Clown1/ClownEnemyTall/AnimationPlayer, $Clown2/CLOWNSHORTMaterial/AnimationPlayer]
@export var clown_model_index = -1

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
