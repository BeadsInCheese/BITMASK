extends Area2D

@onready var level: Level = $".."


func _on_body_entered(body: Node2D) -> void:
	print("here")

	if body is CharacterBody2D:
		print("pla")
		level.go_to_next_level()
