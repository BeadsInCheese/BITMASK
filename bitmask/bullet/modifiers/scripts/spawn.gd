extends BulletModifier

class_name Spawn

@export var prefab: PackedScene


func on_collision(bullet, target):
	var instance = prefab.instantiate()
	instance.global_position = bullet.global_position
	bullet.get_tree().root.add_child(instance)
