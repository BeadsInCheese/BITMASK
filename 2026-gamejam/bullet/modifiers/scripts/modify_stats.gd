extends BulletModifier

class_name ModifyStats

@export var speed_add = 0.0
@export var knock_back_add = 0.0
@export var knock_back_mul = 1.0
@export var damage_add = 0.0
@export var bounces_add = 0
@export var speed_mul = 1.0
@export var damage_mul = 1.0
@export var bullet_spread_mul = 1.0
@export var cooldown_mul = 1.0
@export var extra_bullets_add = 0


func on_ready(bullet):
	bullet.knock_back = (bullet.knock_back + knock_back_add) * knock_back_mul
	bullet.speed = (bullet.speed + speed_add) * speed_mul
	bullet.damage = (bullet.damage + damage_add) * damage_mul
	bullet.bounces += bounces_add
	bullet.bullet_spread *= bullet_spread_mul
	bullet.cooldown *= cooldown_mul
	bullet.extra_bullets += extra_bullets_add
