@tool
extends Area3D

@export var color = Color.RED
@export var texture: Texture

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Sprite3D.texture = texture

func _on_entered(body):
	if body.name == "Player":
		body.mask_up(color, $Sprite3D.texture)
	queue_free()

func _ready() -> void:
	connect("body_entered", _on_entered)
