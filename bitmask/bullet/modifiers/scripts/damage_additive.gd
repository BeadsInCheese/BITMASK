extends BulletModifier
class_name DamageAddative
@export var damage:float


func on_ready(bullet):
	bullet.damage += damage
