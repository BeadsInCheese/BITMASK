extends StatusEffect

class_name AddConsumable
@export var bombs = 0


func on_apply(system):
	system.add_bomb.emit(bombs)
