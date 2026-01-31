extends Node3D

@onready var collider = $Area3D
@onready var level = $/root/Main

signal caught

func _ready() -> void:
	collider.connect("body_entered", func(body):
		print("body entered, checking if it's player")
		if body == level.player:
			caught.emit())
