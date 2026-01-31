class_name Level
extends Node2D

@onready var player: CharacterBody2D = $"../Player"
@onready var spawnpoint: Node2D = $Spawnpoint

@export var next_level: PackedScene


func _ready() -> void:
	player.position = spawnpoint.position


func go_to_next_level():
	add_sibling(next_level.instantiate())
	queue_free()
