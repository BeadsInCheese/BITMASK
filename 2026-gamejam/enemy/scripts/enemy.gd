extends RigidBody2D

@export var stats : Resource

func _process(delta):
	var velocity = Vector2()
	
	velocity.x += find_parent("game").get_node("Player").position.x - position.x
	velocity.y += find_parent("game").get_node("Player").position.y - position.y
	position += velocity * delta

func take_damage(f: float):
	get_node("HPSystem").take_damage(f)


func _on_enemy_death() -> void:
	
