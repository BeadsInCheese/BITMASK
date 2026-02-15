class_name Player
extends CharacterBody2D

@export var speed = 200
@export var shoot_offset = 2
@export var bullet_base: PackedScene
@export var max_ammo = 100

var upgrades: Array[BulletModifier]
var current_ammo
var can_shoot = true
var stagger_cooldown = false

signal on_out_of_ammo
signal on_ammo_changed(value)


func _ready() -> void:
	current_ammo = max_ammo
	on_ammo_changed.emit(current_ammo)

	on_out_of_ammo.connect(func(): $NoAmmoAudioPlayer.play())


func reload(delay: float = 0.5):
	current_ammo = 0
	await get_tree().create_timer(delay, false, false, true).timeout
	current_ammo = max_ammo
	on_ammo_changed.emit(current_ammo)


func apply_status(status):
	$StatusSystem.apply_status(status)


func shoot(direction: Vector2):
	if !can_shoot:
		return

	if current_ammo <= 0:
		can_shoot = false
		return

	current_ammo -= 1
	on_ammo_changed.emit(current_ammo)

	if (current_ammo <= 0):
		on_out_of_ammo.emit()
		reload(1.5)

	can_shoot = false

	var bullet = bullet_base.instantiate()
	bullet.modifiers += upgrades
	bullet.global_position = global_position + direction * shoot_offset
	bullet.direction = direction
	get_tree().root.get_node("game").get_child(0).add_child(bullet)
	for i in bullet.extra_bullets:
		var bullet2 = bullet_base.instantiate()
		bullet2.modifiers += upgrades
		bullet2.global_position = global_position + direction * shoot_offset
		bullet2.direction = direction
		get_tree().root.get_node("game").get_child(0).add_child(bullet2)

	$ShootAudioPlayer.play()
	$Cooldown.wait_time = bullet.cooldown
	$Cooldown.start()


var shoot_dir: Vector2 = Vector2(0, 0)


func _process(delta: float) -> void:
	shoot_dir *= 0
	if Input.is_action_pressed("shoot_mouse"):
		shoot(-(global_position - get_global_mouse_position()).normalized())
	if Input.is_action_pressed("reload"):
		reload()
	velocity = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	shoot_dir += Vector2(Input.get_axis("shoot_left", "shoot_right"), Input.get_axis("shoot_up", "shoot_down"))
	if (shoot_dir.length_squared() > 0):
		shoot(shoot_dir.normalized())

	velocity = velocity.normalized() * speed
	move_and_slide()
	velocity = Vector2(0, 0)


func add_weapon_effect(effect):
	upgrades.append(effect)


func take_damage(f: float):
	if !stagger_cooldown:
		get_node("HPSystem").take_damage(f)
		$HUD/HpLabel.update_label()
		$StaggerTimer.start()
		stagger_cooldown = true


func _on_cooldown_timeout() -> void:
	can_shoot = true


func _on_death() -> void:
	get_tree().paused = true
	$GameOverScreen.visible = true


func _on_stagger_timer_timeout() -> void:
	stagger_cooldown = false
	$StaggerTimer.stop()
