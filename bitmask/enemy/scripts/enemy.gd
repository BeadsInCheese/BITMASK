class_name Enemy
extends CharacterBody2D

@export var stats: Resource

var player
@export var speed: float = 70.0
#var has_target = true
var loot_table: LootTable
signal destroyed

var item_base = preload("res://item/scenes/items.tscn")
var target = Vector2()
var movement_force = Vector2()


func _ready() -> void:
	player = find_parent("game").get_node("Player")
	$HPSystem.current_hp = stats.max_hp
	$Sprite2D.texture = stats.texture
	speed = stats.speed
	loot_table = stats.loot_table
	var parent = get_parent()
	if parent and parent.has_method("_on_enemy_destroyed"):
		destroyed.connect(parent._on_enemy_destroyed)

	$AINode.type = stats.behavior_type

	if stats.behavior_type == 2:
		$HPBar.visible = true
	reroll_target()


func on_collision(body, normal):
	if body.has_method("take_damage"):
		body.take_damage(stats.ce)
		set_collision_mask_value(3, false)


func apply_force(knock_back: Vector2):
	movement_force += knock_back


func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	if !player:
		return
	if stats.behavior_type == 2: # stationary
		return

	if (player.position - global_position).length() > 360:
		set_collision_mask_value(3, true)

	velocity = target - global_position
	var query = PhysicsRayQueryParameters2D.create(global_position, 50 * velocity.normalized())
	query.exclude = [self]
	var results = space_state.intersect_ray(query)

	while velocity.length() < 0.5 && results.is_empty():
		reroll_target()
		velocity = target - global_position
		query = PhysicsRayQueryParameters2D.create(global_position, 50 * velocity.normalized())
		query.exclude = [self]
		results = space_state.intersect_ray(query)

	move_and_collide(velocity.normalized() * delta * 70)

	if (player.position - global_position).length() < 550:
		$NavigationAgent2D.target_position = player.position

		if $NavigationAgent2D.is_navigation_finished():
			return

		var next_path = $NavigationAgent2D.get_next_path_position()
		var direction = (next_path - position).normalized()

		var accel = stats.accel * max(speed - max(movement_force.normalized().dot(direction), 0) * movement_force.length(), 0)

		movement_force += direction * accel

		velocity = movement_force
		movement_force = movement_force * 0.9
		look_at(position + velocity)
		move_and_slide()

		for i in get_slide_collision_count():
			var collision_info = get_slide_collision(i)
			#print("Collided with: ", collision.get_collider().name)
			if (collision_info && collision_info.get_collider() is Player):
				on_collision(collision_info.get_collider(), collision_info.get_normal())


func take_damage(f: float):
	get_node("HPSystem").take_damage(f)
	if stats.behavior_type == 2:
		$HPBar.value = get_node("HPSystem").current_hp / stats.max_hp


func apply_status(status):
	$StatusSystem.apply_status(status)


func modify_speed(multiplier):
	speed *= multiplier


func reroll_target():
	target = Vector2(randi_range(global_position.x - 250, global_position.x + 250), randi_range(global_position.y - 250, global_position.y + 250))


func drop_item(item):
	var item_instance = item_base.instantiate()
	item_instance.item_data = item
	item_instance.global_position = global_position
	get_tree().root.get_node("game").get_child(0).call_deferred("add_child", item_instance)


func _on_enemy_death() -> void:
	var rng = randf()
	var sum = 0
	for loot in loot_table.entrys:
		sum += loot.prob
		if sum > rng:
			drop_item(loot.item)
			break
	destroyed.emit(stats.required_to_destroy)
	self.queue_free()


func _on_pos_timer_timeout() -> void:
	reroll_target()
