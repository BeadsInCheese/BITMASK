extends CharacterBody2D

@export var collision_particle_effect: PackedScene
var direction: Vector2
var speed = 1000
var damage = 20
var bounces = 0
var knock_back = 0
var bullet_spread = 0.5
var cooldown = 0.5
var extra_bullets = 0
@export var modifiers: Array[BulletModifier]

var bodies = []


func _ready() -> void:
	var angle = atan2(direction.x, direction.y) + (randf() - 0.5) * bullet_spread
	direction = Vector2(sin(angle), cos(angle))
	for modifier in modifiers:
		modifier.on_ready(self)
	rotation = -atan2(direction.x, direction.y)


func get_close_bodies():
	return bodies


func _process(delta: float) -> void:
	$proximityField.get_overlapping_bodies()
	rotation = -atan2(direction.x, direction.y)
	var collision_info = move_and_collide(direction * speed * delta)
	if (collision_info):
		on_collision(collision_info.get_collider(), collision_info.get_normal())
	for modifier in modifiers:
		modifier.on_process(self)


func _on_kill_timer_timeout() -> void:
	queue_free()


func on_collision(body, normal) -> void:
	for modifier in modifiers:
		modifier.on_collision(self, body)
	var particle_effect = collision_particle_effect.instantiate()
	particle_effect.global_position = global_position
	get_tree().root.add_child(particle_effect)

	if body.has_method("take_damage"):
		body.take_damage(damage)
	if bounces <= 0:
		for modifier in modifiers:
			modifier.on_destroy(self)
		queue_free()
	else:
		direction = -direction.reflect(normal)
		position += direction * 5
		bounces -= 1


func _on_proximity_field_body_entered(body: Node2D) -> void:
	bodies.append(body)


func _on_proximity_field_body_exited(body: Node2D) -> void:
	bodies.erase(body)
