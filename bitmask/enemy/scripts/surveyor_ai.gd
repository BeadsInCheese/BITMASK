extends Node2D

@export var shoot_offset = 2
@export var bullet_base: PackedScene
@export var beam_base: PackedScene
@export var orb_base: PackedScene
@export var hacker_bullet_base: PackedScene
var player
var type = 0
#@onready var player: CharacterBody2D = $"../Player"
var is_cooldown = false
var cooldown = 5
var burst = 5000
var velocity = Vector2()
var offset
var searching = false
var charging = false
var bursting = false
var player_position
var k = 0
var orth_vec = Vector2(0, 0)


func _ready() -> void:
	offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	if get_parent().stats.behavior_type == 0: #ranged enemy, start shoot() -logic
		$ShootTimer.start()

	player = find_parent("game").get_node("Player")

	searching = true

	#func _draw():
	#if get_parent().stats.behavior_type == 2:
	#return
	#if !player_position:
	#player_position = player.global_position
	#draw_line(Vector2(0,0),player_position - global_position,Color.AQUA)
	#draw_line(Vector2(0,0)+orth_vec,player_position - global_position+orth_vec,Color.AQUA)
	#draw_line(Vector2(0,0)-orth_vec,player_position - global_position-orth_vec,Color.AQUA)


func _process(delta: float) -> void:
	if get_parent().stats.behavior_type == 2:
		return

	if (player.global_position - global_position).length() > 200: #stop attacking when player is far away
		charging = false
		$ChargeTimer.stop()
		return

	#player_position = player.global_position
	queue_redraw()

	if !player_position:
		player_position = player.global_position

	var results: Array[Dictionary]

	if !charging && !bursting:
		var space_state = get_world_2d().direct_space_state
		var mask = 1
		#print(get_parent().get_node("CollisionShape2D").get_viewport_rect())
		var half_bound = get_parent().get_node("CollisionShape2D").get_shape().get_rect().size / 2
		var y = -(player_position.x - global_position.x) ** 2 / (player_position.y - global_position.y) + global_position.y
		orth_vec = (Vector2(player_position.x, y) - global_position).normalized() * half_bound

		#ensure there is space for charging, or firing the beam
		var query = PhysicsRayQueryParameters2D.create(global_position, player_position, mask, [self])
		var temp = space_state.intersect_ray(query)
		if temp.size() != 0:
			results.append(temp)
		query = PhysicsRayQueryParameters2D.create(global_position + orth_vec, player_position + orth_vec, mask, [self])
		temp = space_state.intersect_ray(query)
		if temp.size() != 0:
			results.append(temp)
		query = PhysicsRayQueryParameters2D.create(global_position - orth_vec, player_position - orth_vec, mask, [self])
		temp = space_state.intersect_ray(query)
		if temp.size() != 0:
			results.append(temp)

		#for i in range(0,8):
		#var query = PhysicsRayQueryParameters2D.create(global_position, player_position, mask, [self])
		#var temp = space_state.intersect_ray(query)
		#if temp.size() == 0:
		#results.append(temp)

	#print(results)
	if results.size() == 0 && !bursting:
		player_position = player.global_position
		if get_parent().stats.behavior_type == 1 && $ChargeCooldown.is_stopped():
			charging = true
			if ($ChargeTimer.is_stopped()):
				$ChargeTimer.start()
		elif get_parent().stats.behavior_type == 3 && $BeamCooldown.is_stopped():
			bursting = true

		#print("line of sight to player!, start chaaarrggiiiinng!!!")

	if charging:
		print($ChargeTimer.time_left)
		print("charging, ", (player_position - global_position).length(), " ", $ChargeTimer.time_left)
		if $ChargeTimer.wait_time - $ChargeTimer.time_left < 0.7:
			get_parent().move_and_collide(delta * 15 * Vector2(randf_range(-10, 10), randf_range(-10, 10)))
		else:
			if (player_position - global_position).length() < 10:
				charging = false
				$ChargeCooldown.start()
				print("stopped charging")
			var dir = (player_position - global_position).normalized()
			get_parent().move_and_collide(delta * dir * 540 * sin(PI / (2 * $ChargeTimer.wait_time) * ($ChargeTimer.wait_time - $ChargeTimer.time_left)) ** 4)

	if bursting:
		print(burst, " ", int(burst) % 2, " ", burst < 0)
		burst -= delta * 200
		if (int(burst) % 2 == 0):
			shoot((player_position - global_position).normalized(), beam_base.instantiate(), 450)
		if burst < 0:
			burst = 5000
			bursting = false
			$BeamCooldown.start()


func shoot(direction, bullet, speed):
	bullet.global_position = global_position + direction * shoot_offset
	bullet.direction = direction
	bullet.damage = get_parent().stats.bullet_dmg
	bullet.speed = speed
	get_tree().root.get_node("game").get_child(0).add_child(bullet)


func _on_shoot_timer_timeout() -> void:
	$CooldownTimer.start()
	$ShootTimer.stop()


func _on_cooldown_timer_timeout() -> void:
	offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	$ShootTimer.start()
	$CooldownTimer.stop()


func _on_timer_timeout() -> void:
	if (!$ShootTimer.is_stopped() && player):
		velocity = player.global_position + offset - global_position
		shoot(velocity.normalized(), bullet_base.instantiate(), 400)


func _on_charge_timer_timeout() -> void:
	charging = false
	$ChargeCooldown.start()


func _on_charge_cooldown_timeout() -> void:
	pass # Replace with function body.
