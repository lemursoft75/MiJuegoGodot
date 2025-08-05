extends CharacterBody2D
class_name Enemy

@export var move_speed := 400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_bar: HealthBar = $HealthBar


var can_move := true

func _process(delta: float) -> void:
	var player_dir := GameManager.player.global_position - global_position
	var direction := player_dir.normalized()
	var movement = direction * move_speed
	velocity = movement
	
	if not can_move:
		return
	
	if player_dir.length() <= 150:
		return
	
	move_and_slide()
	animated_sprite_2d.flip_h = true if velocity.x < 0 else false

func _on_health_component_on_damaged() -> void:
	var health_value = health_component.current_health / health_component.max_health
	health_bar.set_value(health_value)
	animated_sprite_2d.material = GameManager.HIT_MATERIAL
	await get_tree().create_timer(0.3).timeout
	animated_sprite_2d.material = null
	
	
func _on_health_component_on_defeated() -> void:
	can_move = false
	health_bar.hide()
	animated_sprite_2d.play("dead")
	collision_shape_2d.set_deferred("disabled", true)
	
	await animated_sprite_2d.animation_finished
	GameManager.on_enemy_died.emit()
	GameManager.create_coin(global_position)
	queue_free()



func _on_hit_area_2d_body_entered(player: Player) -> void:
	player.health_component.take_damage(2)
	GameManager.play_damage_text(player.global_position, 2)
