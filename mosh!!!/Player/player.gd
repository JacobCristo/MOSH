extends CharacterBody2D

var movement_speed = 80.0
var hp = 80
var last_movement = Vector2.UP

#Attack
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")

#Attack Nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")

#Ice Spear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 1
var tornado_attackspeed = 1
var tornado_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	attack()

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
		last_movement = mov
		if x_mov < 0:
			sprite.flip_h = true
		elif x_mov > 0:
			sprite.flip_h = false
	else:
		sprite.play("idle")
	move_and_slide()

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()	
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed
		if tornadoTimer.is_stopped():
			tornadoTimer.start()	
			
func _on_hurtbox_hurt(damage: Variant, _angle:Variant, _knockback:Variant) -> void:
	hp -= damage
	print(hp)

func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
			
func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_baseammo
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
