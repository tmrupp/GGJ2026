extends CharacterBody3D

var speed = 5.0
var turn_speed = .05

var direction: Vector2
var turn: float
@onready var cam = $CameraPivot/SpringArm3D/Camera3D

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Forward", "Back")
	turn = Input.get_axis("CounterClockwise", "Clockwise")
	
	
func _physics_process(_delta: float) -> void:
	velocity = Vector3(direction.x, 0.0, direction.y).rotated(Vector3.UP, rotation.y) * speed
	rotate(Vector3(0, 1, 0), turn*turn_speed)
	move_and_slide()
