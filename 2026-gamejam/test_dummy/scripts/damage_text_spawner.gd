extends Node2D
@export var damage_text_base:PackedScene

func create_text(damage):
	var damage_text=damage_text_base.instantiate()
	damage_text.text=str(damage)
	add_child(damage_text)
