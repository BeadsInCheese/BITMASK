extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$"..".go_to_next_level()
