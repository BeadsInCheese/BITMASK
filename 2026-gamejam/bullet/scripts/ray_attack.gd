extends CharacterBody2D

@export var collision_particle_effect: PackedScene
var direction = Vector2()
var speed = 1000
var damage


func _process(delta: float) -> void:
	var collision_info = move_and_collide(direction * speed * delta)
	if (collision_info):
		on_collision(collision_info.get_collider(), collision_info.get_normal())


func on_collision(body, normal):
	if body is Player && body.has_method("take_damage"):
		body.take_damage(0.05)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
