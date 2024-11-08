extends CharacterBody2D

class_name EnemyBody

@export var movement_speed = 40.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite: AnimatedSprite2D = $EnemyBase/AnimatedSprite2D
@onready var snd_hit: AudioStreamPlayer2D = $EnemyBase/snd_hit
@onready var snd_death: AudioStreamPlayer2D = $EnemyBase/snd_death
@onready var hitbox: Area2D = $EnemyBase/Hitbox
@onready var hurtbox: Area2D = $EnemyBase/Hurtbox
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hide_timer: Timer = $EnemyBase/HideTimer


var exp_gem = preload("res://Objects/experience_gem.tscn")

signal remove_from_array(object)

#Performance
var screen_size

func _ready() -> void:
	add_to_group("enemy")
	hitbox.damage = enemy_damage
	screen_size = get_viewport_rect().size
	hurtbox.connect("hurt", Callable(self, "_on_hurtbox_hurt"))
	hide_timer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))

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
	hurtbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitoring", false)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
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
		
func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount: 
		collision.call_deferred("set", "disabled", true)
		#sprite.stop()

func _on_hide_timer_timeout() -> void:
	var location_diff = global_position - player.global_position
	if abs(location_diff.x) > (screen_size.x/2) * 1.4 || abs(location_diff.y) > (screen_size.y/2) * 1.4:
		visible = false
	else:
		visible = true
