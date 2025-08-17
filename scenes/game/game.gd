extends Node2D
class_name Game

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var crosshair: Sprite2D = $Crosshair
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var weapons: Node2D = $Weapons
@onready var wave_label: Label = %WaveLabel
@onready var enemy_count_label: Label = %EnemyCountLabel
@onready var coins_label: Label = %CoinsLabel
@onready var wave_timer: Timer = $WaveTimer

var boss_fight := false   # 👉 flag de jefe

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameManager.player = player
	wave_timer.start()

	if not enemy_spawner.on_wave_completed.is_connected(_on_enemy_spawner_on_wave_completed):
		enemy_spawner.on_wave_completed.connect(_on_enemy_spawner_on_wave_completed)

	if not enemy_spawner.on_boss_incoming.is_connected(_on_boss_incoming):
		enemy_spawner.on_boss_incoming.connect(_on_boss_incoming)

func _physics_process(delta: float) -> void:
	camera.global_position = player.global_position
	var target_pos := get_global_mouse_position()
	crosshair.global_position = crosshair.global_position.lerp(target_pos, delta * 20.0)

	# 👉 Solo mostrar diablillos si no es boss fight
	if not enemy_spawner.boss_spawned and not boss_fight:
		wave_label.text = "Vienen diablillos en:\n%d" % int(wave_timer.time_left)
		enemy_count_label.text = "Diablillos: %s" % str(enemy_spawner.enemies_remainig)

	coins_label.text = str(GameManager.coins)

func _on_enemy_spawner_on_wave_completed(wave_number: int) -> void:
	weapons.show()
	wave_label.show()
	enemy_count_label.hide()
	wave_timer.start()

func _on_wave_timer_timeout() -> void:
	weapons.hide()
	wave_label.hide()
	enemy_count_label.show()
	enemy_spawner.start_enemy_timer()

# 📌 Aviso de jefe final (solo 3 seg)
func _on_boss_incoming() -> void:
	boss_fight = true   # 👉 activar flag para que no se pise el mensaje

	wave_label.text = "¡EL JEFE FINAL LLEGÓ!"
	wave_label.show()
	enemy_count_label.hide()
	wave_timer.stop()

	await get_tree().create_timer(3.0).timeout
	wave_label.hide()   # 👈 se oculta después de 3 segundos
