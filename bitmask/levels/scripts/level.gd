class_name Level
extends Node2D

@onready var player: CharacterBody2D = $"../Player"
@onready var spawnpoint: Node2D = $Spawnpoint

@export var next_level: PackedScene

var databases_to_kill = 0


func _ready() -> void:
	player.position = spawnpoint.position
	for child in get_children():
		if child is Enemy and child.stats.required_to_destroy:
			databases_to_kill += 1


func go_to_next_level():
	add_sibling(next_level.instantiate())
	queue_free()


func _on_enemy_destroyed(required_to_score) -> void:
	if required_to_score:
		databases_to_kill -= 1
	if databases_to_kill == 0:
		go_to_next_level()
