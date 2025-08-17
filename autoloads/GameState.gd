extends Node


var selected_weapon_res_path: String = ""  # ruta del .tres/.res de arma
var revive_available: bool = true
var coins: int = 0

func save_from_game(player):
	coins = GameManager.coins

	# Buscar nodo Game y leer revive_available si existe
	var game_node = get_tree().root.get_node_or_null("Game")
	if game_node and game_node.has_variable("revive_available"):
		revive_available = game_node.revive_available
	else:
		revive_available = true

	# Guardar ruta del arma
	if player.weapon and player.weapon.weapon_data:
		selected_weapon_res_path = player.weapon.weapon_data.resource_path

func apply_to_player(player):
	# Restaurar arma
	if selected_weapon_res_path != "":
		var wpn: Resource = load(selected_weapon_res_path)
		if wpn:
			player.setup_weapon(wpn)

	# Vida llena al entrar al boss
	if player.has_node("HealthComponent"):
		player.health_component.set_full_health()
	if player.has_node("HealthBar") and "set_value" in player.health_bar:
		player.health_bar.set_value(1.0)
