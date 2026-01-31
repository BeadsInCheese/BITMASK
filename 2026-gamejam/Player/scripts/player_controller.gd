extends CharacterBody2D

@export var speed = 200
@export var shoot_offset = 2
@export var bullet_base: PackedScene
@export var max_ammo = 100
var current_ammo
var can_shoot = true
signal on_out_of_ammo
signal on_ammo_changed(value)


func _ready() -> void:
	current_ammo = max_ammo


func reload():
	current_ammo = 0
	await get_tree().create_timer(0.5, false, false, true).timeout
	current_ammo = max_ammo
	on_ammo_changed.emit(current_ammo)


func shoot(direction: Vector2):
	if !can_shoot || current_ammo <= 0:
		return
	current_ammo -= 1
	on_ammo_changed.emit(current_ammo)
	if (current_ammo <= 0):
		on_out_of_ammo.emit()
	can_shoot = false
	$Cooldown.start()
	var bullet = bullet_base.instantiate()
	bullet.global_position = global_position + direction * shoot_offset
	bullet.direction = direction
	get_tree().root.add_child(bullet)
	$ShootAudioPlayer.play()


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


func _on_cooldown_timeout() -> void:
	can_shoot = true
