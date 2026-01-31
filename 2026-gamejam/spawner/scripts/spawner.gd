extends Node2D

@export var scene_to_spawn : PackedScene
@export_range(0.0, 100.0, 0.1) var wait_time = 5.0

func _ready() -> void:
	$Timer.wait_time = wait_time

func _on_timer_timeout() -> void:
	var scene = scene_to_spawn.instantiate()
	scene.position = position
	get_parent().add_child(scene)
