class_name Enemy
extends CharacterBody2D

@export var stats: Resource

var player
@export var speed: float = 70.0
var target = true
var loot_table: LootTable
signal destroyed

var item_base = preload("res://item/scenes/items.tscn")

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


func on_collision(body, normal):
	if body.has_method("take_damage"):
		body.take_damage(stats.ce)


func apply_force(knock_back: Vector2):
	movement_force += knock_back


func _physics_process(delta: float) -> void:
	if !player:
		return
	if stats.behavior_type == 2: # stationary
		return

	$NavigationAgent2D.target_position = player.position

	if $NavigationAgent2D.is_navigation_finished():
		return

	var next_path = $NavigationAgent2D.get_next_path_position()
	var direction = (next_path - position).normalized()

	var accel = stats.accel * max(speed - max(movement_force.normalized().dot(direction), 0) * movement_force.length(), 0)

	movement_force += direction * accel

	velocity = movement_force
	movement_force = movement_force * 0.9
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


func drop_item(item):
	var item_instance = item_base.instantiate()
	item_instance.item_data = item
	item_instance.global_position = global_position
	get_tree().root.call_deferred("add_child", item_instance)


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
