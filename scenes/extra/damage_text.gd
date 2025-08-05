extends Control
class_name DamageText

@onready var damage_label: Label = $DamageLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_text(value: int) -> void:
	damage_label.text = str(value)
