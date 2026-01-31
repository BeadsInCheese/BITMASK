extends RigidBody2D

@export var stats : Resource
var player

func _ready() -> void:
	player = find_parent("game").get_node("Player")

func _process(delta):
	var velocity = Vector2()
	
	velocity.x += player.position.x - position.x
	velocity.y += player.position.y - position.y
	position += velocity * delta

func take_damage(f: float):
	get_node("HPSystem").take_damage(f)

func _on_enemy_death() -> void:
	self.queue_free()
