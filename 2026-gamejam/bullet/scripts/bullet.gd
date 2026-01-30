extends RigidBody2D
var direction:Vector2
var speed=40
var damage=1

@export var modifiers:Array[BulletModifier]
func _ready() -> void:
	for modifier in modifiers:
		modifier.on_ready(self)
	rotation=-atan2(direction.x,direction.y)
	
	
func _process(delta: float) -> void:
	linear_velocity=direction*speed
	rotation=-atan2(direction.x,direction.y)
	move_and_collide(linear_velocity)


func _on_kill_timer_timeout() -> void:
	queue_free()


func on_collision(body: Node) -> void:
	for modifier in modifiers:
		modifier.on_collision(self,body)
	body.take_damage(damage)
	queue_free()
