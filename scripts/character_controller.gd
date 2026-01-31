extends CharacterBody3D

var speed = 1.0
var direction

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("Left", "Right", "Forward", "Back")
	
func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, direction.y, 0.0)  * speed
	move_and_slide()
