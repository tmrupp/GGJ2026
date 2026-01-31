extends Node3D

@onready var player = $Player

signal caught

func _ready() -> void:
	caught.connect(_on_player_caught)

func _on_player_caught():
	print("we caught the player")
