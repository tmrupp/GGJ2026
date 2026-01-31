extends Node3D

@onready var collider = $Area3D
@onready var level = $/root/Main
@onready var raycast = $RayCast3D

func _ready() -> void:
	collider.connect("body_entered", func(body):
		if body == level.player:
			raycast.look_at(level.player.position)
			raycast.force_raycast_update()
			if raycast.get_collider() == level.player:
				level.caught.emit())
