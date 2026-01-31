extends Node2D

@export var modifiers: Array[BulletModifier]


func _on_area_2d_area_entered(area) -> void:
	for modifier in modifiers:
		modifier.on_collision(self, area)


func _on_area_2d_area_exited(area) -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	queue_free()
