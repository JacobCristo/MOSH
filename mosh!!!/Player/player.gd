extends CharacterBody2D

var movement_speed = 80.0
var hp = 80
var last_movement = Vector2.UP
var time = 0

var experience = 0
var level = 1
var collected_experience = 0
var max_hp = 80

#Attack
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")
var fireball = preload("res://Player/Attack/fireball.tscn")
var flamethrower = preload("res://Player/Attack/flamethrower.tscn")

#Attack Nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var javelin_base = get_node("%JavelinBase")
@onready var fireballTimer = get_node("%FireballTimer")
@onready var fireballAttackTimer = get_node("%FireballAttackTimer")
@onready var flamethrowerTimer = get_node("%FlamethrowerTimer")
@onready var flamethrowerAttackTimer = get_node("%FlamethrowerAttackTimer")
#Upgrades
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#Ice Spear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 5
var tornado_level = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0

#Fireball
var fireball_ammo = 0
var fireball_baseammo = 0
var fireball_attackspeed = 0.75
var fireball_level = 0

#Flamethrower
var flamethrower_ammo = 0
var flamethrower_baseammo = 0
var flamethrower_attackspeed = 0.25
var flamethrower_level = 0

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
@onready var healthBar = get_node("%HealthBar")
@onready var label_timer = get_node("%label_timer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var item_container = preload("res://Player/GUI/item_container.tscn")

@onready var death_panel = get_node("%DeathPanel")
@onready var label_result = get_node("%label_results")
@onready var snd_victory = get_node("%snd_victory")
@onready var snd_lose = get_node("%snd_lose")

signal player_death()

func _ready() -> void:
	upgrade_character("icespear1") #start off with a weapon
	_on_hurtbox_hurt(0, 0, 0)
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
		iceSpearTimer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()	
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()	
	if javelin_level > 0:
		spawn_javelin()
	if fireball_level > 0:
		fireballTimer.wait_time = fireball_attackspeed * (1 - spell_cooldown)
		if fireballTimer.is_stopped():
			fireballTimer.start()
	if flamethrower_level > 0:
		flamethrowerTimer.wait_time = flamethrower_attackspeed * (1 - spell_cooldown)
		if flamethrowerTimer.is_stopped():
			flamethrowerTimer.start()
			
func _on_hurtbox_hurt(damage: Variant, _angle:Variant, _knockback:Variant) -> void:
	hp -= clamp(damage - armor, 1, 999) #guarantee at least one damage
	healthBar.max_value = max_hp
	healthBar.value = hp
	if hp <= 0:
		death()

func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo + additional_attacks
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
	tornado_ammo += tornado_baseammo + additional_attacks
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
			
func _on_fireball_timer_timeout() -> void:
	fireball_ammo += fireball_baseammo + additional_attacks
	fireballAttackTimer.start()


func _on_fireball_attack_timer_timeout() -> void:
	if fireball_ammo > 0:
		var fireball_attack = fireball.instantiate()
		fireball_attack.position = position
		fireball_attack.target = get_random_target()
		fireball_attack.level = fireball_level
		add_child(fireball_attack)
		fireball_ammo -= 1
		if fireball_ammo > 0:
			fireballAttackTimer.start()
		else:
			fireballAttackTimer.stop()

func _on_flamethrower_timer_timeout() -> void:
	flamethrower_ammo += flamethrower_baseammo + additional_attacks
	flamethrowerAttackTimer.start()

func _on_flamethrower_attack_timer_timeout() -> void:
	if flamethrower_ammo > 0:
		var target = get_closest_target() #targets closest
		var flamethrower_attack = flamethrower.instantiate()
		flamethrower_attack.position = position
		flamethrower_attack.target = target
		flamethrower_attack.level = flamethrower_level
		add_child(flamethrower_attack)
		flamethrower_ammo -= 1
		if flamethrower_ammo > 0:
			flamethrowerAttackTimer.start()
		else:
			flamethrowerAttackTimer.stop()
			
func spawn_javelin():
	var get_javelin_total = javelin_base.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelin_base.add_child(javelin_spawn)
		calc_spawns -= 1
	#update javelin
	var get_javelins = javelin_base.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func get_closest_target() -> Vector2:
	if enemy_close.size() > 0:
		return get_closest_enemy(global_position, enemy_close).global_position
	else:
		return Vector2.UP

func get_closest_enemy(current_position: Vector2, enemies):
	var closest_enemy = null
	var closest_distance:float = 1e20  # Initialize with a large number
	
	for enemy in enemies:
		var distance = current_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy	
	return closest_enemy
		
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
		exp_cap = 95 * (level - 19) * 8
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
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true
	
func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"fireball1":
			fireball_level = 1
			fireball_baseammo = 1
		"fireball2":
			fireball_level = 2
			fireball_baseammo += 1
		"fireball3":
			fireball_level = 3
		"fireball4":
			fireball_level = 4
			fireball_baseammo += 2
		"flamethrower1":
			flamethrower_level = 1
			flamethrower_baseammo = 15
		"flamethrower2":
			flamethrower_level = 2
		"flamethrower3":
			flamethrower_level = 3
		"flamethrower4":
			flamethrower_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 40.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,max_hp)
	
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	level_panel.visible = false
	level_panel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #find already collected upgrades
			pass
		elif i in upgrade_options: #if the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for prereqs
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var random_item = dblist.pick_random()
		upgrade_options.append(random_item)
		return random_item
	else:
		return null
		
func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	label_timer.text = str(get_m, ":", get_s)
	
func adjust_gui_collection(upgrade):
	var get_upgraded_display_name = UpgradeDb.UPGRADES[upgrade]["display_name"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_display_names = []
		for i in collected_upgrades:
			get_collected_display_names.append(UpgradeDb.UPGRADES[i]["display_name"])
		if not get_upgraded_display_name in get_collected_display_names:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
					
func death():
	death_panel.visible = true
	emit_signal("player_death")
	get_tree().paused = true
	var tween = death_panel.create_tween()
	tween.tween_property(death_panel, "position", Vector2(220, 50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	if time >= 300:
		label_result.text = "You win!"
		snd_victory.play()
	else:
		label_result.text = "You lose!"
		snd_lose.play()
	
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

func _on_button_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://Title Screen/menu.tscn")
