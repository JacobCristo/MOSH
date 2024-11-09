extends Area2D

var level = 1
var hp = 1
var speed = 200
var damage = 2.5
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var snd_throw: AudioStreamPlayer = $snd_throw
@onready var snd_explode: AudioStreamPlayer = $snd_explode
@onready var splash_collision: CollisionShape2D = $SplashArea/CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D

signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(90)
	match level:
		1, 2:
			hp = 1
			speed = 250
			damage = 5
			knock_amount = 250
			attack_size = 1.0
		3, 4:
			hp = 1
			speed = 250
			damage = 8
			knock_amount = 250
			attack_size = 1.0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
			
func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	sprite.play("explosion")
	snd_explode.play()
	splash_collision.call_deferred("set", "disabled", false)
	get_tree().create_timer(0.1).connect("timeout", func(): splash_collision.call_deferred("set", "disabled", true))
	
	particles.emitting = true
	get_tree().create_timer(0.25).connect("timeout", func(): queue_free())
	
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		collision.call_deferred("set", "disabled", true)

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()

func _on_snd_explode_finished() -> void:
	queue_free()
