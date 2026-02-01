class_name Player
extends CharacterBody2D

@export var speed = 200
@export var shoot_offset = 2
@export var bullet_base: PackedScene
@export var max_ammo = 100

var upgrades: Array[BulletModifier]
var current_ammo
var can_shoot = true

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

	print(current_ammo)
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
	get_tree().root.add_child(bullet)
	for i in bullet.extra_bullets:
		var bullet2 = bullet_base.instantiate()
		bullet2.modifiers += upgrades
		bullet2.global_position = global_position + direction * shoot_offset
		bullet2.direction = direction
		get_tree().root.add_child(bullet2)

	$ShootAudioPlayer.play()
	$Cooldown.wait_time = bullet.cooldown
	$Cooldown.start()


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot_mouse"):
		shoot(-(global_position - get_global_mouse_position()).normalized())
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("reload"):
		reload()

	velocity = velocity.normalized() * speed
	move_and_slide()
	velocity = Vector2(0, 0)


func add_weapon_effect(effect):
	upgrades.append(effect)


func take_damage(f: float):
	get_node("HPSystem").take_damage(f)
	$HUD/HpLabel.update_label()
	#print(get_node("HPSystem").current_hp)


func _on_cooldown_timeout() -> void:
	can_shoot = true


func _on_death() -> void:
	get_tree().paused = true
	$GameOverScreen.visible = true
