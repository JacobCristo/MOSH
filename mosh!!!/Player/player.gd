extends CharacterBody2D

var movement_speed = 40.0

func _physics_process(delta: float) -> void:
	movement()
	
func movement():
	#direction of movement in the x direction
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction of movement in the y direction
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	velocity = mov.normalized() * movement_speed
	move_and_slide()
