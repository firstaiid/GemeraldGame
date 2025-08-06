extends Node

func player_pos(value: Vector2):
	EventHandler.emit_signal("player_pos", value)

func vril_coin_collected():
	EventHandler.emit_signal("vril_coin_collected")

func rage_enemy_squished():
	EventHandler.emit_signal("rage_enemy_squished")
	
func gassy_powerup_collected():
	EventHandler.emit_signal("gassy_powerup_collected")

func player_hurt(value: float):
	EventHandler.emit_signal("player_hurt", value)
	
func player_health(value: float):
	EventHandler.emit_signal("player_health", value)
	
func pause():
	EventHandler.emit_signal("pause")
	
func developer_console():
	EventHandler.emit_signal("developer_console")

func print_to_console(value: String):
	EventHandler.emit_signal("print_to_console", value)
