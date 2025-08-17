extends Node
class_name EnemySpawner

signal on_wave_completed(wave_number)
signal on_boss_incoming   # 📌 Señal para avisar al HUD

const SPAWN_ANIM = preload("res://scenes/extra/spawn_anim.tscn")

enum SpawnType {
	RandomTimer,
	FixedTimer
}

@export var spawn_type: SpawnType
@export var min_random: float
@export var max_random: float
@export var fixed_timer: float
@export var enemies_per_wave := 5
@export var enemy_list: Array[PackedScene] = []
@export var boss_scene: PackedScene
@export var boss_wave := 6   # Oleada en la que aparece el jefe

@onready var timer: Timer = $Timer

var enemies_remainig: int
var spawned_enemies: int
var wave_number: int = 1
var boss_spawned := false

func _ready() -> void:
	GameManager.on_enemy_died.connect(_on_enemy_died)
	enemies_remainig = enemies_per_wave

# --------------------------------------------------------
# Spawner normal de enemigos
# --------------------------------------------------------
func spawn_enemy() -> void:
	if wave_number == boss_wave and not boss_spawned:
		boss_spawned = true
		_spawn_boss()
		return

	# Spawn anim y enemigo normal
	var spawn_anim: SpawnAnim = SPAWN_ANIM.instantiate()
	var pos_x = randf_range(-1000, 1000)
	var pos_y = randf_range(-1000, 1000)
	var spawn_pos := Vector2(pos_x, pos_y)
	spawn_anim.global_position = spawn_pos
	add_child(spawn_anim)

	await spawn_anim.on_spawn_enemy
	spawn_anim.queue_free()

	var random_enemy = enemy_list.pick_random() as PackedScene
	var enemy = random_enemy.instantiate()
	enemy.global_position = spawn_pos
	add_child(enemy)

	spawned_enemies += 1
	start_enemy_timer()

func start_enemy_timer() -> void:
	timer.wait_time = get_new_timer()
	timer.start()

func get_new_timer() -> float:
	return randf_range(min_random, max_random) if spawn_type == SpawnType.RandomTimer else fixed_timer

func _on_timer_timeout() -> void:
	if spawned_enemies >= enemies_per_wave:
		return
	spawn_enemy()

# --------------------------------------------------------
# Oleadas normales
# --------------------------------------------------------
func _on_enemy_died() -> void:
	enemies_remainig -= 1
	if enemies_remainig <= 0:
		timer.stop()
		GameManager.set_checkpoint(wave_number, boss_wave)
		on_wave_completed.emit(wave_number)

		# 📌 Si la próxima oleada es el jefe
		if wave_number + 1 == boss_wave:
			on_boss_incoming.emit()   # 🔥 Avisar al HUD
			wave_number += 1
			boss_spawned = false
			
			# ⏳ Espera 3 seg para que se muestre el mensaje
			await get_tree().create_timer(3.0).timeout
			_spawn_boss()  # 👈 Aquí aparece el jefe
			return

		# 📌 Si no es jefe, seguimos normal
		if wave_number < boss_wave:
			wave_number += 1
			enemies_per_wave += 2
			enemies_remainig = enemies_per_wave
			spawned_enemies = 0


# --------------------------------------------------------
# Boss
# --------------------------------------------------------
func _spawn_boss() -> void:
	timer.stop()

	# 💖 Curar al jugador al entrar en pelea de jefe
	if GameManager.player and GameManager.player.health_component:
		GameManager.player.health_component.current_health = GameManager.player.health_component.max_health
		GameManager.player._on_health_component_on_damaged()

	var boss = boss_scene.instantiate()
	boss.global_position = Vector2(0, 0) # posición central
	add_child(boss)

	boss.health_component.on_defeated.connect(_on_boss_defeated)

func _on_boss_defeated() -> void:
	print("¡Jefe derrotado!")

	# Esperar animación de muerte del jefe (2s)
	await get_tree().create_timer(2.0).timeout  

	# Luego mostrar popup de victoria
	var popup = preload("res://scenes/ui/victory_popup.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
