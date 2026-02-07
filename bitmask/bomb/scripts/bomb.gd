extends Node2D

var explosion_prefab = preload("res://bullet/modifiers/scenes/explosion.tscn")


func explode():
	var explosion_instance = explosion_prefab.instantiate()
	explosion_instance.global_position = global_position

	get_tree().root.get_node("game").get_child(0).call_deferred("add_child", explosion_instance)
	queue_free()
