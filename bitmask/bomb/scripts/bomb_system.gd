extends Node2D

var bomb_prefab = preload("res://bomb/scenes/bomb.tscn")

var max_bombs
var current_bombs = 100


func add_bomb(amount: int):
	if current_bombs + amount > max_bombs:
		current_bombs = max_bombs
	else:
		current_bombs += amount


func drop_bomb():
	if current_bombs < 1:
		return
	current_bombs -= 1
	var bomb_instance = bomb_prefab.instantiate()
	bomb_instance.global_position = global_position
	get_tree().root.get_node("game").get_child(0).call_deferred("add_child", bomb_instance)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bomb"):
		drop_bomb()
