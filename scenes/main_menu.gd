extends Control

func _on_iniciar_juego_pressed():
	# 🔄 Resetear progreso antes de empezar nueva partida
	GameManager.reset()

	# Sonido del botón
	$VBoxContainer/Button/Button_Click_Sound.play()

	# Cargar la escena del juego
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_opciones_pressed():
	$VBoxContainer/Button2/Button_Click_Sound.play()
	print("El botón de Opciones fue presionado.")


func _on_salir_pressed():
	$VBoxContainer/Button3/Button_Click_Sound.play()
	get_tree().quit()
