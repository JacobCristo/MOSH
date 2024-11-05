extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = load(str(i.enemy.resource_path))
				var counter = 0 
				while counter < i.enemy_number:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
					
func get_random_position():
	var vpr = get_viewport_rect().size
	# Choose negative side or positive side. (randi()%2 - 0.5) * 2 will randomly choose from -1 and 1. 
	# The `* 2` is cancelled out.
	var side_shift = Vector2(randi() % 2 - 0.5, randi() % 2 - 0.5) 
	# Choose a random position from the area
	var random_shift = Vector2(randf_range(1.1, 1.4), randf_range(1.1, 1.4))
	var spawn_position = player.global_position - random_shift * side_shift * vpr
	return spawn_position
