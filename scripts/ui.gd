extends TextureRect

@onready var player = $"../../Player"

var audio

func play_music (stream):
	if audio:
		audio.stop()
	audio = stream
	audio.play()

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
	get_tree().reload_current_scene.call_deferred()
	
func game_end():
	play_music($"../../Audio/End")
	$"../GameEndPanel".visible = true
	$"../..".process_mode = Node.PROCESS_MODE_DISABLED
	$"../GameEndPanel/VBoxContainer/Label3".text = str(player.nmasks)

func _ready() -> void:
	$Panel/VBoxContainer/Start.pressed.connect(toggle)
	$Panel/VBoxContainer/Exit.pressed.connect(get_tree().quit)
	$"../GameEndPanel/VBoxContainer/Restart".pressed.connect(restart)
	
	play_music($"../../Audio/Menu")
