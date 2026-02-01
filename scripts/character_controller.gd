extends CharacterBody3D

var default_speed = 5.0
var white_speed_factor = 1.2
var speed = 5.0
var turn_speed = .05

@onready var ability_bar = $SubViewport/ProgressBar
var direction: Vector2
var turn: float
@onready var cam = $CameraPivot/SpringArm3D/Camera3D
@onready var mesh = $MeshInstance3D
@onready var animation_player = $Node3D/ClownPlayer/AnimationPlayer
@onready var shader = $Node3D/ClownPlayer/rig/Skeleton3D/Torus

#var mask: Color = Color.WHITE
@onready var mask_sprite = $Node3D/ClownPlayer/mask
var color: Color = Color.WHITE

const color_dictionary = {
	Color.RED : Color.RED,
	Color.BLUE : Color(0, 115, 255),
	Color.YELLOW : Color.YELLOW,
	Color.WHITE : Color.WHITE
}

var cooldown_step = 0.1
func cooldown(time):
	ability_bar.visible = true
	var t = 0.0
	while t < time:
		ability_bar.value = t/time
		#print("ability_bar.value=", ability_bar.value, " time=", time, " t=", t)
		await get_tree().create_timer(cooldown_step).timeout
		t += cooldown_step
	
	ability_bar.visible = false
		

var shielded = false
func shield(first_time = true):
	if first_time:
		shielded = true

var dash_cooldown = 3.0
func dash(first_time = true):
	if first_time or ability_bar.visible:
		return
	
	speed = 1000
	cooldown(dash_cooldown)

var shroud_time = 2.0
var shroud_cooldown = 6.0
var shrouded = false
func shroud(first_time = true):
	if first_time or ability_bar.visible:
		return
		
	cooldown(shroud_cooldown)
	
	var t = 0
	shrouded = true
	shader.get_surface_override_material(0).set_shader_parameter("color_focus", Color.BLACK)
	while t < shroud_time:
		await get_tree().create_timer(cooldown_step).timeout
		t += cooldown_step
		
	shrouded = false
	shader.get_surface_override_material(0).set_shader_parameter("color_focus", color_dictionary[color])
	

func default(first_time = true):
	pass

var ability = {
	Color.WHITE : default,
	Color.RED : dash,
	Color.BLUE : shroud,
	Color.YELLOW : shield,
}

func _ready() -> void:
	animation_player.set_blend_time("walk", "idle", 0.25)
	animation_player.set_blend_time("idle", "walk", 0.2)
	ability_bar.visible = false

func mask_up (_color, texture):
	print("masking up")
	color = _color
	ability[color].call()
	mask_sprite.texture = texture
	shader.get_surface_override_material(0).set_shader_parameter("color_focus", color_dictionary[color])

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Forward", "Back")
	turn = Input.get_axis("CounterClockwise", "Clockwise")

	if _event.is_action_pressed("Ability"):
		ability[color].call(false)
	
func _physics_process(_delta: float) -> void:
	if shrouded:
		velocity = Vector3.ZERO
		return
	velocity = Vector3(direction.x, 0.0, direction.y).rotated(Vector3.UP, rotation.y) * speed
	
	speed = default_speed * (white_speed_factor if color == Color.WHITE else 1)
	rotate(Vector3(0, 1, 0), turn * turn_speed)
	move_and_slide()

func _process(_delta: float) -> void:
	animation_player.speed_scale = (white_speed_factor if color == Color.WHITE else 1)
	if animation_player.current_animation != "walk" and velocity.length_squared() > 1e-3:
		animation_player.play("walk")
	elif animation_player.current_animation != "idle" and velocity.length_squared() <= 1e-3:
		animation_player.play("idle")
