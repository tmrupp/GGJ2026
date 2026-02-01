extends Node

@onready var tents = get_children()
@onready var enemy_scene = preload("res://scenes/enemy.tscn")
@onready var main = $"../.."

func spawn():
	var t = randi_range(0, tents.size()-1)
	var enemy = enemy_scene.instantiate()
	enemy.position = tents[t].position + Vector3.UP
	
	main.add_child(enemy)
	
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		spawn()
