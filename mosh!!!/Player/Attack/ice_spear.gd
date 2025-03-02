extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_break: AudioStreamPlayer = $snd_break
@onready var particles: CPUParticles2D = $CPUParticles2D

signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(90)
	match level:
		1, 2:
			hp = 1
			speed = 300
			damage = 10
			knock_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		3, 4:
			hp = 2
			speed = 300
			damage = 15
			knock_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
			
func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		collision.call_deferred("set", "disabled", true)
		sprite.play("break")
		snd_break.play()

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
	
func _on_snd_break_finished() -> void:
	queue_free()
