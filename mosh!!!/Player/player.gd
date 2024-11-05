extends CharacterBody2D

var movement_speed = 40.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	movement()
	
func movement():
	#direction of movement in the x direction
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction of movement in the y direction
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	velocity = mov.normalized() * movement_speed
	if Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		sprite.play("walk")
		if x_mov < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play("idle")
	move_and_slide()
