@tool
extends Node3D

@onready var models = [$Clown1, $Clown2]
@export var clown_model_index = -1

func _ready() -> void:
	set_model()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_model()

func set_model():
	if clown_model_index >= 0 and clown_model_index < len(models):
		for model in models:
			model.hide()
		models[clown_model_index].show()
