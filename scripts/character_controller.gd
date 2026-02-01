extends CharacterBody3D

var speed = 5.0
var turn_speed = .05

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
	Color.YELLOW : Color.YELLOW
}

func _ready() -> void:
	animation_player.set_blend_time("walk", "idle", 0.25)
	animation_player.set_blend_time("idle", "walk", 0.2)

func mask_up (_color, texture):
	color = _color
	mask_sprite.texture = texture
	shader.get_surface_override_material(0).set_shader_parameter("color_focus", color_dictionary[color])

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Forward", "Back")
	turn = Input.get_axis("CounterClockwise", "Clockwise")
	
func _physics_process(_delta: float) -> void:
	velocity = Vector3(direction.x, 0.0, direction.y).rotated(Vector3.UP, rotation.y) * speed
	rotate(Vector3(0, 1, 0), turn * turn_speed)
	move_and_slide()

func _process(_delta: float) -> void:
	if animation_player.current_animation != "walk" and velocity.length_squared() > 1e-3:
		animation_player.play("walk")
	elif animation_player.current_animation != "idle" and velocity.length_squared() <= 1e-3:
		animation_player.play("idle")
