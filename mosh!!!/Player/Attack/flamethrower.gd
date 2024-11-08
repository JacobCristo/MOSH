extends Area2D

var level = 1
var hp = 3
var speed = 500
var damage = 1
var knock_amount = 10
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var snd_throw: AudioStreamPlayer = $snd_throw
@onready var snd_explode: AudioStreamPlayer = $snd_explode
@onready var particles: CPUParticles2D = $CPUParticles2D

signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(90)
	particles.rotation = rotation

	match level:
		1:
			hp = 2
			speed = 250
			damage = 1
			knock_amount = 10
			attack_size = 1.0
		2:
			hp = 3
			speed = 250
			damage = 1.5
			knock_amount = 10
			attack_size = 1.0
		3:
			hp = 5
			speed = 250
			damage = 1.5
			knock_amount = 10
			attack_size = 1.0
		4:
			hp = 5
			speed = 250
			damage = 2
			knock_amount = 10
			attack_size = 1.25
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
			
func _physics_process(delta: float) -> void:
	position += angle * speed * delta	
	
func enemy_hit(charge = 1):
	sprite.play("explosion")
	snd_explode.play()
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		collision.call_deferred("set", "disabled", true)

func _on_timer_timeout() -> void:
	sprite.play("explosion")
	await sprite.animation_finished
	queue_free()

func _on_snd_explode_finished() -> void:
	queue_free()
