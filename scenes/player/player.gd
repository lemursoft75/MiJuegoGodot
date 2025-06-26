extends CharacterBody2D
class_name Player

@export var move_speed := 700.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D


var can_move := true

func _process(delta: float) -> void:
	if not can_move:
		return
	update_animations()
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement := direction * move_speed
	velocity = movement
	move_and_slide()
	
func update_animations() -> void:
	if velocity.length() > 0:
		anim_sprite.play("move")
	else:
		anim_sprite.play("idle")
			
		
		
		
