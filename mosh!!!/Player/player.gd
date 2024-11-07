extends CharacterBody2D

var movement_speed = 80.0
var hp = 80
var last_movement = Vector2.UP

var experience = 0
var level = 1
var collected_experience = 0

#Attack
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")

#Attack Nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var javelin_base = get_node("%JavelinBase")

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

#Javelin
var javelin_ammo = 2
var javelin_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $AnimatedSprite2D

#GUI
@onready var exp_bar = get_node("%ExperienceBar")
@onready var label_level = get_node("%LabelLevel")
@onready var level_panel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var snd_levelup = get_node("%snd_levelup")
@onready var itemOptions = preload("res://Utility/item_option.tscn")

func _ready() -> void:
	attack()
	set_expbar(experience, calculate_experience_cap())


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
	if javelin_level > 0:
		spawn_javelin()
			
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
			
func spawn_javelin():
	var get_javelin_total = javelin_base.get_child_count()
	var calc_spawns = javelin_ammo - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelin_base.add_child(javelin_spawn)
		calc_spawns -= 1

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experience_cap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required - experience
		level += 1
		label_level.text = str("Level: ", level)
		experience = 0
		exp_required = calculate_experience_cap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_expbar(experience, exp_required)

func calculate_experience_cap():
	var exp_cap = level
	if level < 20:
		exp_cap = level * 5
	elif level < 40:
		exp_cap + 95 * (level - 19) * 8
	else:
		exp_cap = 255 + (level - 39) * 12
	return exp_cap
	
func set_expbar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func levelup():
	snd_levelup.play()
	label_level.text = str("Level: ", level)
	var tween = level_panel.create_tween()
	tween.tween_property(level_panel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	level_panel.visible = true
	var options = 0
	var options_max = 3
	while (options < options_max):
		var option_choice = itemOptions.instantiate()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true
	
func upgrade_character(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	level_panel.visible = false
	level_panel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)
	
func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		calculate_experience(gem_experience)
