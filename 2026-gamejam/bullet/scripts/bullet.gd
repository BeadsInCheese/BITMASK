extends RigidBody2D
var direction:Vector2
var speed=40
func _process(delta: float) -> void:
	linear_velocity=direction*speed
	move_and_collide(linear_velocity)
