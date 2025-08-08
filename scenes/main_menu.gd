# main_menu.gd
extends Control

@onready var transition_rect = $VBoxContainer/Panel/TransitionRect
@onready var animation_player = $VBoxContainer/Panel/AnimationPlayer


func _on_iniciar_juego_pressed():
	# La ruta correcta es ahora a través de VBoxContainer
	$VBoxContainer/Button/Button_Click_Sound.play()

	# Carga la escena del juego
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_opciones_pressed():
	# Ruta para el segundo botón
	$VBoxContainer/Button2/Button_Click_Sound.play()
	print("El botón de Opciones fue presionado.")

func _on_salir_pressed():
	# Ruta para el tercer botón
	$VBoxContainer/Button3/Button_Click_Sound.play()
	get_tree().quit()
