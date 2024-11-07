extends Area2D

@export var experience = 1

var sprite_green = preload("res://Assets/MOSH_Basic_Exp.png")
var sprite_blue = preload("res://Assets/MOSH_Better_Exp.png")
var sprite_red = preload("res://Assets/MOSH_Best_Exp.png")

var target = null
var speed = -1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var snd_collected: AudioStreamPlayer = $snd_collected

func _ready() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = sprite_blue
	else: 
		sprite.texture = sprite_red
		
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta
	
func collect():
	snd_collected.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience

func _on_snd_collected_finished() -> void:
	queue_free()
