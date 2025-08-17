extends Node
class_name HealthComponent

signal on_defeated
signal on_damaged

@export var max_health := 10
@export var damage_resistance := 1.0  # 1.0 = daño normal, 0.5 = recibe mitad, 2.0 = recibe doble

var current_health: float 

func _ready() -> void:
	current_health = max_health

func take_damage(value: float) -> void:
	if current_health <= 0:
		return
	
	var real_damage = value * damage_resistance
	current_health -= real_damage
	on_damaged.emit()
	
	if current_health <= 0:
		current_health = 0
		on_defeated.emit()
