extends Node2D

@export var scene_to_spawn: PackedScene
@export_range(0.0, 100.0, 0.1) var wait_time = 5.0

var max_enemies = 30

var enemy_resources = {
	"probe": preload("res://enemy/scripts/probe.tres"),
	"surveyor": preload("res://enemy/scripts/surveyor.tres"),
	"ocre": preload("res://enemy/scripts/ocre.tres")
}


func _ready() -> void:
	$Timer.wait_time = wait_time


func get_spawned_enemy_count():
	var count = 0
	for child in get_parent().get_children():
		if child is Enemy and not child.stats.required_to_destroy:
			count += 1

	return count


func _on_timer_timeout() -> void:
	if get_spawned_enemy_count() > max_enemies:
		return

	var scene = scene_to_spawn.instantiate()
	if "stats" in scene:
		var rand_idx = randi() % enemy_resources.size()
		var random_key = enemy_resources.keys()[rand_idx]
		var random_enemy = enemy_resources[random_key]
		scene.stats = random_enemy
	scene.position = position
	get_parent().add_child(scene)
