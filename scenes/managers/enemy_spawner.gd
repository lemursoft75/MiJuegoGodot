extends Node
class_name EnemySpawner

signal on_wave_completed(wave_number)

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

@onready var timer: Timer = $Timer

var enemies_remainig: int
var spawned_enemies: int
var wave_number: int = 1  # 📌 Nueva variable para la oleada

func _ready() -> void:
	GameManager.on_enemy_died.connect(_on_enemy_died)
	enemies_remainig = enemies_per_wave

func spawn_enemy() -> void:
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

func _on_enemy_died() -> void:
	enemies_remainig -= 1
	if enemies_remainig <= 0:
		timer.stop()
		on_wave_completed.emit(wave_number)
		wave_number += 1
		enemies_per_wave += 2  # Aumenta 2 enemigos cada oleada
		enemies_remainig = enemies_per_wave
		spawned_enemies = 0
