extends Node3D

@onready var player = $Player

signal caught

func _ready() -> void:
	caught.connect(_on_player_caught)

func _on_player_caught():
	
	if player.shrouded:
		return
		
	if player.shielded:
		player.shielded = false
		player.mask_up(Color.WHITE, null)
		print("player shielded, not caught")
		
	else:
		print("we caught the player")
