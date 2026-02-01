extends Area3D

@export var color = Color.RED
#@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_entered(body):
	if body.name == "Player":
		body.mask_up(color, $Sprite3D.texture)
	queue_free()

func _ready() -> void:
	connect("body_entered", _on_entered)
