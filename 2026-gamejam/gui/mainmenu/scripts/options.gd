extends CanvasLayer

@onready var main_menu: MainMenu = $".."


func _ready() -> void:
	%MasterVolume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	%Music.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("music"))
	%SFX.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("sfx"))

	GlobalHandler.audio_mute_toggled.connect(func(value: float): %MasterVolume.value = value)


func _on_back_pressed() -> void:
	main_menu.options_scene.queue_free()


func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("music"), value)


func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("sfx"), value)
