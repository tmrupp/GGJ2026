extends TextureRect

func toggle ():
	self.visible = not self.visible
	if self.visible:
		$"../..".process_mode = Node.PROCESS_MODE_DISABLED
	else:
		$"../..".process_mode = Node.PROCESS_MODE_INHERIT

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle()
		
func restart ():
	get_tree().reload_current_scene.call_deferred()
	
func game_end():
	$"../GameEndPanel".visible = true
	$"../..".process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	$VBoxContainer/Start.pressed.connect(toggle)
	$VBoxContainer/Exit.pressed.connect(get_tree().quit)
	$"../GameEndPanel/VBoxContainer/Restart".pressed.connect(restart)
