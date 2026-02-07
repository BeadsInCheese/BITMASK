class_name MainMenu
extends Node2D

func _on_go_to_game_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://game.tscn"))


func refocus():
	$VBoxContainer/GoToGame.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()


var options_scene


func _on_options_pressed() -> void:
	options_scene = preload("res://gui/mainmenu/scenes/options.tscn").instantiate()
	add_child(options_scene)
