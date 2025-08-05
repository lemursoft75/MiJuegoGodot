extends Node2D
class_name Weapon

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var fire_pos: Marker2D = %FirePos
@onready var muzzle: Sprite2D = %Muzzle
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var fire_sound: AudioStreamPlayer = $"../FireSound"

var delay_btw_shots: float
var equipped_weapon: WeaponData

func _process(delta: float) -> void:
	delay_btw_shots -= delta
	if delay_btw_shots <= 0:
		if not equipped_weapon: return
		if Input.is_action_pressed("shoot"):
			shoot_weapon()
			delay_btw_shots = equipped_weapon.delay_btw_shots

func setup(weapon_data: WeaponData) -> void:
	equipped_weapon = weapon_data
	weapon_sprite.texture = weapon_data.weapon_sprite
	weapon_sprite.self_modulate = weapon_data.weapon_color
	delay_btw_shots = weapon_data.delay_btw_shots
	fire_pos.position = weapon_data.fire_pos
	muzzle.position = Vector2(weapon_data.fire_pos.x + 90, weapon_data.fire_pos.y)

func shoot_weapon() -> void:
	var bullet_instance: Bullet = equipped_weapon.bullet_scene.instantiate()
	bullet_instance.global_position = fire_pos.global_position
	bullet_instance.damage = equipped_weapon.damage
	bullet_instance.move_direction = (get_global_mouse_position() - global_position).normalized()
	animation_player.play("shoot")
	fire_sound.play()
	GameManager.on_camera_shake.emit()
	get_tree().root.add_child(bullet_instance)

func rotate_weapon(value: bool) -> void:
	if value:
		weapon_sprite.scale.y = -1.5
	else:
		weapon_sprite.scale.y = 1.5
