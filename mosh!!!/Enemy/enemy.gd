extends CharacterBody2D

@export var movement_speed = 40.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $AnimatedSprite2D
@onready var snd_hit = $snd_hit
@onready var snd_death = $snd_death

var exp_gem = preload("res://Objects/experience_gem.tscn")

signal remove_from_array(object)

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	#direction to the player
	var direction = global_position.direction_to(player.global_position)
	if direction.x < 0.1:
		sprite.flip_h = true
	elif direction.x > -0.1: 
		sprite.flip_h = false
		
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()

func death():
	sprite.play("death")
	snd_death.play()
	emit_signal("remove_from_array", self)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = 1
	loot_base.call_deferred("add_child", new_gem)
	await sprite.animation_finished
	queue_free()
	

func _on_hurtbox_hurt(damage: Variant, angle:Variant, knock_amount:Variant) -> void:
	hp -= damage
	knockback = angle * knock_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
