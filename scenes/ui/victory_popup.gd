extends CanvasLayer

@onready var btn_exit: Button = $Control/VBoxContainer/BtnExit
@onready var victory_sound: AudioStreamPlayer = $VictorySound

func _ready() -> void:
	get_tree().paused = true
	btn_exit.pressed.connect(_on_exit_pressed)
	victory_sound.play()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
