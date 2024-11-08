extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var time = 0

var enemy_cap = 500
var enemies_to_spawn = []

const Reaper = preload("res://Enemy/reaper.gd")

signal change_time(time)

func _ready():
	connect("change_time", Callable(player, "change_time"))

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	var my_children = get_children()
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = load(str(i.enemy.resource_path))
				#print(i.enemy)
				var counter = 0 
				while counter < i.enemy_number:
					if new_enemy is Reaper:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_random_position()
						add_child(enemy_spawn)
					elif my_children.size() <= enemy_cap:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_random_position()
						add_child(enemy_spawn)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
	if my_children.size() <= enemy_cap and enemies_to_spawn.size() > 0:
		var spawn_number = clamp(enemies_to_spawn.size(), 1, 50) - 1
		var counter = 0
		while counter < spawn_number:
			var new_enemy = enemies_to_spawn[0].instantiate()
			new_enemy.global_position = get_random_position()
			add_child(new_enemy)
			enemies_to_spawn.remove_at(0)
			counter += 1
	emit_signal("change_time", time)
					
func get_random_position():
	var vpr = get_viewport_rect().size
	# Choose negative side or positive side. (randi()%2 - 0.5) * 2 will randomly choose from -1 and 1. 
	# The `* 2` is cancelled out.
	var side_shift = Vector2(randi() % 2 - 0.5, randi() % 2 - 0.5) 
	# Choose a random position from the area
	var random_shift = Vector2(randf_range(1.1, 1.4), randf_range(1.1, 1.4))
	var spawn_position = player.global_position - random_shift * side_shift * vpr
	return spawn_position
