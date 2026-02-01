extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gui/mainmenu/scenes/mainmenu.tscn")
