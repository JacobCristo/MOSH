extends CharacterBody2D

@export var movement_speed = 40.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	#direction to the player
	var direction = global_position.direction_to(player.global_position)
	if direction.x < 0:
		sprite.flip_h = true
	else: 
		sprite.flip_h = false
		
	velocity = direction * movement_speed
	move_and_slide()
