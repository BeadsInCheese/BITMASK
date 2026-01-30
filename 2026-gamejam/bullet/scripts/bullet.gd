extends CharacterBody2D
var direction:Vector2
var speed=40
var damage=1

@export var modifiers:Array[BulletModifier]
func _ready() -> void:
	for modifier in modifiers:
		modifier.on_ready(self)
	rotation=-atan2(direction.x,direction.y)
	
	
func _process(delta: float) -> void:
	rotation=-atan2(direction.x,direction.y)
	var collision_info = move_and_collide(direction*speed)
	if(collision_info):
		on_collision(collision_info.get_collider())

func _on_kill_timer_timeout() -> void:
	queue_free()


func on_collision(body) -> void:
	for modifier in modifiers:
		modifier.on_collision(self,body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
