extends Node

@onready var tents = get_children()
@onready var enemy_scene = preload("res://scenes/enemy.tscn")
@onready var main = $"../.."

var colors = [Color.BLUE, Color.RED, Color.YELLOW]

func spawn():
	var t = randi_range(0, tents.size()-1)
	var enemy = enemy_scene.instantiate()
	enemy.transform = tents[t].transform
	enemy.position += Vector3.UP
	enemy.setup(colors.pick_random(), randi_range(0, 1))
	main.add_child(enemy)
	
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		spawn()
