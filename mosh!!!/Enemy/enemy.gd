extends CharacterBody2D

@export var movement_speed = 40.0
@export var hp = 10

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	#direction to the player
	var direction = global_position.direction_to(player.global_position)
	if direction.x < 0.1:
		sprite.flip_h = true
	elif direction.x > -0.1: 
		sprite.flip_h = false
		
	velocity = direction * movement_speed
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	if hp >= 0:
		queue_free()
