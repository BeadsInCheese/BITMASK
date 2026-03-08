extends Area2D

@export var next_area: CanvasItem


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		next_area.visible = true
