extends Node

@onready var mask_scene = preload("res://scenes/mask.tscn")
@onready var mask_pngs = {Color.BLUE:"res://Art/2d art/bluemask.png", Color.RED:"res://Art/2d art/redmask.png", Color.YELLOW:"res://Art/2d art/yellowmask.png"}

@onready var floor = $"../NavigationRegion3D/BackgroundTent"

var timer: Timer

func spawn_mask (color: Color):
	print("spawn")
	var v = floor._random_world_loc()
	var mask = mask_scene.instantiate()
	mask.setup(color, load(mask_pngs[color]))
	mask.position = v + Vector3.UP
	add_child(mask)
	timer.start(10)
	
	
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	timer = Timer.new()
	timer.timeout.connect(spawn_mask.bind(mask_pngs.keys().pick_random()))
	add_child(timer)
	timer.start(10)
	for c in mask_pngs.keys():
		spawn_mask(c)
		
	#for i in range(1000):
		#var c = mask_pngs.keys().pick_random()
		#spawn_mask(c)

func remove_mask (mask):
	var color = mask.color
	mask.queue_free()
	spawn_mask(color)
	
	
