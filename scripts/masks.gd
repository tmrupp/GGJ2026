extends Node

@onready var mask_scene = preload("res://scenes/mask.tscn")
@onready var mask_pngs = {Color.BLUE:"res://Art/2d art/bluemask.png", Color.RED:"res://Art/2d art/redmask.png", Color.YELLOW:"res://Art/2d art/yellowmask.png"}

@onready var floor = $"../NavigationRegion3D/Floor"


func spawn_mask (color: Color):
	var v = floor._random_world_loc()
	var mask = mask_scene.instantiate()
	mask.setup(color, load(mask_pngs[color]))
	mask.position = v + Vector3.UP
	add_child(mask)
	
func _ready() -> void:
	for c in mask_pngs.keys():
		spawn_mask(c)

func remove_mask (mask):
	var color = mask.color
	mask.queue_free()
	spawn_mask(color)
	
	
