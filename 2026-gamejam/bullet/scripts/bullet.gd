extends CharacterBody2D
@export var collision_particle_effect:PackedScene
var direction:Vector2
var speed=10
var damage=1
var bounces=2

@export var modifiers:Array[BulletModifier]
func _ready() -> void:
	for modifier in modifiers:
		modifier.on_ready(self)
	rotation=-atan2(direction.x,direction.y)
	
	
func _process(delta: float) -> void:
	rotation=-atan2(direction.x,direction.y)
	var collision_info = move_and_collide(direction*speed)
	if(collision_info):
		on_collision(collision_info.get_collider(),collision_info.get_normal())
	
func _on_kill_timer_timeout() -> void:
	queue_free()


func on_collision(body,normal) -> void:
	for modifier in modifiers:
		modifier.on_collision(self,body)
	var particle_effect=collision_particle_effect.instantiate()
	particle_effect.global_position=global_position
	get_tree().root.add_child(particle_effect)
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if bounces<=0:
		queue_free()
	else:
		direction=-direction.reflect(normal)
		position+=direction*5
		bounces-=1
