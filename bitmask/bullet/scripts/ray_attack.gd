extends CharacterBody2D

@export var collision_particle_effect: PackedScene
var direction = Vector2()
var speed = 400
var damage = 1
var life_time = 1.0
var t = 0


func _process(delta: float) -> void:
	var collision_info = move_and_collide(direction * speed * delta)
	if (collision_info):
		on_collision(collision_info.get_collider(), collision_info.get_normal())
	t += delta
	if t > life_time:
		queue_free()


func on_collision(body, normal):
	if body is Player && body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
