extends Node

@onready var tents = get_children()
@onready var enemy_scene = preload("res://scenes/enemy.tscn")
@onready var main = $"../.."

var colors = [Color.BLUE, Color.RED, Color.YELLOW]

var S = 10
var R = .5
var E = 2

func next_timer():
	S = maxf(S-R, E)
	return S
	
func _ready() -> void:
	spawn()

func spawn():
	var t = randi_range(0, tents.size()-1)
	while true:
		var enemy = enemy_scene.instantiate()
		enemy.transform = tents[t].transform
		enemy.position += Vector3.UP
		enemy.setup(colors.pick_random(), randi_range(0, 1))
		main.add_child.call_deferred(enemy)
		var nt = next_timer()
		await get_tree().create_timer(nt).timeout
