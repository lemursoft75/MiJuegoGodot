extends CharacterBody2D
class_name Player


@export var move_speed := 700.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: HealthBar = $HealthBar

var can_move := true
var mouse_pos: Vector2


func _process(delta: float) -> void:
	if not can_move:
		return
	get_mouse_pos()	
	update_animations()
	update_player_rotation()
	update_weapon_rotation()
		
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement := direction * move_speed
	velocity = movement
	move_and_slide()

func setup_weapon(weapon_data: WeaponData) -> void:
	weapon.setup(weapon_data)
	weapon.show()

func update_player_rotation() -> void:
	if mouse_pos.x > global_position.x:
		anim_sprite.flip_h = false
	else:
		anim_sprite.flip_h = true

func update_weapon_rotation() -> void:
	if mouse_pos.x > global_position.x:
		weapon.rotate_weapon(false)
	else:
		weapon.rotate_weapon(true)
	weapon.look_at(mouse_pos)			
	
func update_animations() -> void:
	if velocity.length() > 0:
		anim_sprite.play("move")
	else:
		anim_sprite.play("idle")
		
func get_mouse_pos()	-> void:
	mouse_pos = get_global_mouse_position()
		

func _on_health_component_on_damaged() -> void:
	var health_value = health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	anim_sprite.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	anim_sprite.material = null


func _on_health_component_on_defeated() -> void:
	anim_sprite.play("dead")
	can_move = false
