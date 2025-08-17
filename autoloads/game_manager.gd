extends Node

signal on_enemy_died
signal on_camera_shake

# 🔄 Referencias
var player: Player

# 🔄 Estado de progreso
var coins: int = 20
var checkpoint_wave := 1
var is_boss_fight := false
var continues_left := 3  # Número de oportunidades

# 📦 Recursos
const EXPLOSION_ANIM = preload("res://scenes/extra/explosion_anim.tscn")
const COIN = preload("res://scenes/extra/coin.tscn")
const HIT_MATERIAL = preload("res://scenes/extra/hit_material.tres")
const DAMAGE_TEXT = preload("res://scenes/extra/damage_text.tscn")

# -------------------------------------------------------
# 🔄 FUNCIONES DE EFECTOS VISUALES
# -------------------------------------------------------
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

# -------------------------------------------------------
# 📌 SISTEMA DE CHECKPOINTS
# -------------------------------------------------------
func set_checkpoint(wave_number: int, boss_wave: int) -> void:
	checkpoint_wave = wave_number
	is_boss_fight = (wave_number == boss_wave)

func load_checkpoint() -> void:
	get_tree().paused = false
	if is_boss_fight:
		# Reinicia escena en pelea de jefe
		get_tree().reload_current_scene()
	else:
		# Reinicia escena y salta a la oleada guardada
		get_tree().reload_current_scene()
		await get_tree().process_frame
		var spawner = get_tree().current_scene.get_node("EnemySpawner")
		if spawner:
			spawner.wave_number = checkpoint_wave

# -------------------------------------------------------
# 🔄 RESET GENERAL (cuando empieza nueva partida)
# -------------------------------------------------------
func reset() -> void:
	player = null
	coins = 20
	checkpoint_wave = 1
	is_boss_fight = false
	continues_left = 3

	# Si hay un player cargado, reinicia sus stats
	if player:
		if player.health_component:
			player.health_component.current_health = player.health_component.max_health
		if "reset_stats" in player:
			player.reset_stats()
		if "weapon_manager" in player and player.weapon_manager:
			player.weapon_manager.reset_weapons()

	print("✅ GameManager reseteado")
