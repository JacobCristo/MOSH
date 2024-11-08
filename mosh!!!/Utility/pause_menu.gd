extends Control

@onready var unpause_timer: Timer = $UnpauseTimer
var timesOut = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		visible = true
		unpause_timer.start()
	elif Input.is_action_just_pressed("pause") and timesOut:
		if get_tree().paused:
			timesOut = false
			get_tree().paused = false
			visible = false

func _on_unpause_timer_timeout() -> void:
	timesOut = true
