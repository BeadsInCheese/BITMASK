extends Area2D

@onready var level: Level = $".."


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		level.go_to_next_level()
