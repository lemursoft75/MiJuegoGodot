extends Control

@onready var btn_exit: Button = %BtnExit

func _ready() -> void:
	# conectar botón
	btn_exit.pressed.connect(_on_exit_pressed)

func _on_exit_pressed() -> void:
	# Reiniciar estado del juego
	GameManager.reset()
	# Volver al menú principal
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
