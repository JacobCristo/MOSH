extends Area2D

@onready var attack: Area2D = $".."

var damage = 0
var knock_amount = 0
var angle = Vector2.ZERO

func _ready() -> void:
	
	damage = attack.damage
	knock_amount = attack.knock_amount
	angle = attack.angle
