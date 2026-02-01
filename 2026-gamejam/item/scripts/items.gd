extends Node2D

@export var effects: Array[BulletModifier]
@export var item_data: ItemResource


func _ready() -> void:
	$Visual.texture = item_data.visual
	effects = item_data.effects


func accuire(player):
	queue_free()
	if player.has_method("add_weapon_effect"):
		for effect in effects:
			print("accuired " + item_data.item_name)
			player.add_weapon_effect(effect)
