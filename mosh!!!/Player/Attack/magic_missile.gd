extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var enemy_target = null
var angle = Vector2.ZERO
var current_velocity = Vector2.ZERO
var drag = 0.08 #effective turning speed

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_hit: AudioStreamPlayer = $snd_hit
@onready var particles: CPUParticles2D = $CPUParticles2D

signal remove_from_array(object)

func _ready() -> void:
	if player.enemy_close == []:
		queue_free()
		
	match level:
		1:
			hp = 1
			speed = 225
			damage = 5
			knock_amount = 125
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 225
			damage = 7.5
			knock_amount = 125
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 3
			speed = 225
			damage = 7.5
			knock_amount = 125
			attack_size = 1.0 * (1 + player.spell_size) 
		4:
			hp = 3
			speed = 400
			damage = 15
			knock_amount = 125
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	current_velocity = speed * Vector2.UP.rotated(rotation) #current velocity = speed * forward vector
			
func _physics_process(delta: float) -> void:
	#delete me if there's nobody to hit
	if player.enemy_close == []:
		if particles.emitting:
			emit_signal("remove_from_array", self)
			collision.call_deferred("set", "disabled", true)
			sprite.play("break")
			particles.emitting = false
		
	if not enemy_target in player.enemy_close:
		if not player.enemy_close == []:
			target = player.get_closest_target()
		
	var direction = Vector2.UP.rotated(rotation).normalized()
	if target:
		direction = global_position.direction_to(target)
	
	var desired_velocity = direction * speed
	var previous_velocity = current_velocity
	var change = (desired_velocity - current_velocity) * drag
	
	current_velocity += change
	
	position += current_velocity * delta
	look_at(global_position + current_velocity)

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		collision.call_deferred("set", "disabled", true)
		sprite.play("break")
		particles.emitting = false
		snd_hit.play()

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
	
func _on_snd_hit_finished() -> void:
	queue_free()
