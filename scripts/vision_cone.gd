extends Node3D

@onready var collider = $Area3D
@onready var level = $/root/Main

func _ready() -> void:
	collider.connect("body_entered", func(body):
		if body == level.player:
			level.caught.emit())
