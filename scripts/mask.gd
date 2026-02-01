@tool
extends Area3D

@onready var masks = $".."
@export var color = Color.RED
@export var texture: Texture

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Sprite3D.texture = texture

func setup(color, texture):
	$Sprite3D.texture = texture
	color = color

func _on_entered(body):
	if body.name == "Player":
		body.mask_up(color, $Sprite3D.texture)
	#queue_free()
	masks.remove_mask(self)

func _ready() -> void:
	connect("body_entered", _on_entered)
