extends Node

signal on_enemy_died
signal on_camera_shake

var player: Player
var coins: int = 20

const EXPLOSION_ANIM = preload("res://scenes/extra/explosion_anim.tscn")
const COIN = preload("res://scenes/extra/coin.tscn")
const HIT_MATERIAL = preload("res://scenes/extra/hit_material.tres")
const DAMAGE_TEXT = preload("res://scenes/extra/damage_text.tscn")

func play_explosion_anim(pos: Vector2) -> void:
	var anim: AnimatedSprite2D = EXPLOSION_ANIM.instantiate()
	anim.global_position = pos
	anim.z_index = 99
	get_parent().add_child(anim)
	await anim.animation_finished
	anim.queue_free()

func play_damage_text(pos: Vector2, value: int) -> void:
	var damage = DAMAGE_TEXT.instantiate() as DamageText
	get_parent().add_child(damage)
	damage.global_position = pos
	damage.set_text(value)

func create_coin(pos: Vector2) -> void:
	var random_value := randf_range(0.0, 100.0)
	if random_value <= 70:
		var coin := COIN.instantiate()
		coin.global_position = pos
		get_parent().add_child(coin)

func remove_coins(amount: int) -> void:
	coins -= amount
	if coins <= 0:
		coins = 0
