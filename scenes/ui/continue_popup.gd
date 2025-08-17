extends CanvasLayer

@onready var label_title: Label = $VBoxContainer/Label
@onready var btn_continue: Button = $VBoxContainer/HBoxContainer/BtnContinue
@onready var btn_exit: Button = $VBoxContainer/HBoxContainer/BtnExit

func _ready() -> void:
	if GameManager.continues_left > 0:
		label_title.text = "¿Continuar? (" + str(GameManager.continues_left) + " restantes)"
		btn_continue.disabled = false
	else:
		label_title.text = "Game Over"
		btn_continue.disabled = true

	btn_continue.pressed.connect(_on_continue_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)
	get_tree().paused = true

func _on_continue_pressed() -> void:
	if GameManager.continues_left > 0:
		GameManager.continues_left -= 1
		get_tree().paused = false
		queue_free()
		GameManager.load_checkpoint()
	else:
		_on_exit_pressed()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	GameManager.reset()  # 🔄 Reinicia monedas, continues y progreso
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
