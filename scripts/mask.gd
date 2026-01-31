extends Area3D

@export var color = Color.RED
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_entered(body):
	if body.name == "Player":
		body.mask_up(color)

func _ready() -> void:
	connect("body_entered", _on_entered)
	print("color:", color)
	mesh.mesh.material = StandardMaterial3D.new()
	mesh.mesh.material.albedo_color = color
