extends CharacterBody3D

var speed = 1.0
var direction: Vector2

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Forward", "Back")
	
func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, 0.0, direction.y)  * speed
	move_and_slide()
