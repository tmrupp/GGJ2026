extends TextureRect

@onready var player = $"../../Player"

var audio

func play_music (stream):
	if audio:
		audio.stop()
	audio = stream
	audio.play()
	
@onready var volume_slider = $Panel/VBoxContainer/HBoxContainer/HSlider

func toggle ():
	self.visible = not self.visible
	if self.visible:
		play_music($"../../Audio/Menu")
		$"../..".process_mode = Node.PROCESS_MODE_DISABLED
	else:
		play_music($"../../Audio/Main")
		$"../..".process_mode = Node.PROCESS_MODE_INHERIT

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()
		
func restart ():
	$"../../Audio/Select".play()
	get_tree().reload_current_scene.call_deferred()
	
func volume(_x=true):
	var val = volume_slider.value/100
	print(val)
	for a:AudioStreamPlayer in $"../../Audio".get_children():
		a.volume_linear = val
	
func game_end():
	play_music($"../../Audio/End")
	print("audio?")
	$"../GameEndPanel".visible = true
	$"../..".process_mode = Node.PROCESS_MODE_DISABLED
	$"../GameEndPanel/VBoxContainer/Label3".text = str(player.nmasks)

func _ready() -> void:
	$Panel/VBoxContainer/Start.pressed.connect(toggle)
	$Panel/VBoxContainer/Exit.pressed.connect(get_tree().quit)
	$"../GameEndPanel/VBoxContainer/Restart".pressed.connect(restart)
	volume_slider.drag_ended.connect(volume)
	volume_slider.value = 25
	volume()
	play_music($"../../Audio/Menu")
