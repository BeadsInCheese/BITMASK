extends Node2D
@export var shoot_offset = 2
@export var bullet_base: PackedScene
var player
var type = 0
#@onready var player: CharacterBody2D = $"../Player"
var is_cooldown = false
var cooldown = 5
var burst = 50
var velocity = Vector2()
var offset

func _ready() -> void:
	offset = Vector2(randf_range(-50,50),randf_range(-50,50))
	if get_parent().stats.behavior_type == 0:
		$ShootTimer.start()
	
func shoot(direction):
	var bullet = bullet_base.instantiate()
	bullet.global_position = global_position + direction * shoot_offset
	bullet.direction = direction
	bullet.damage = get_parent().stats.bullet_dmg
	get_tree().root.add_child(bullet)


func _on_shoot_timer_timeout() -> void:
	$CooldownTimer.start()
	$ShootTimer.stop()

func _on_cooldown_timer_timeout() -> void:
	offset = Vector2(randf_range(-50,50),randf_range(-50,50))
	$ShootTimer.start()
	$CooldownTimer.stop()

func _on_timer_timeout() -> void:
	if(!$ShootTimer.is_stopped()):
		player = get_parent().find_parent("game").get_node("Player")
		velocity = player.global_position + offset - global_position
		shoot(velocity.normalized())
