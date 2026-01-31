extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

	if event.is_action_pressed("mute"):
		var master = AudioServer.get_bus_index("Master")
		if AudioServer.get_bus_volume_linear(master) > 0:
			AudioServer.set_bus_volume_linear(master, 0)
		else:
			AudioServer.set_bus_volume_linear(master, 1)
