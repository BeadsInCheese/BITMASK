extends CharacterBody2D

@export var stats : Resource
var player
@export var speed: float = 70.0

func _ready() -> void:
	player = find_parent("game").get_node("Player")
	$HPSystem.current_hp = stats.max_hp
	$Sprite2D.texture = stats.texture
	speed = stats.speed

func on_collision(body,normal):
	if body.has_method("take_damage"):
		body.take_damage(stats.ce)

func _physics_process(delta: float) -> void:
	if !player:
		return
	$NavigationAgent2D.target_position = player.position
	
	if $NavigationAgent2D.is_navigation_finished():
		return
	
	var next_path = $NavigationAgent2D.get_next_path_position()
	var direction = (next_path - position).normalized()
	velocity = direction * speed
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision_info = get_slide_collision(i)
		#print("Collided with: ", collision.get_collider().name)
		if(collision_info && collision_info.get_collider() is Player):
			on_collision(collision_info.get_collider(),collision_info.get_normal())
	

func take_damage(f: float):
	get_node("HPSystem").take_damage(f)
	print(get_node("HPSystem").current_hp)
	
func apply_status(status):
	$StatusSystem.apply_status(status)
	
func modify_speed(multiplier):
	speed*=multiplier
	
	
func _on_enemy_death() -> void:
	self.queue_free()
