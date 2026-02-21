extends Node2D

@export var effects: Array[BulletModifier]
@export var effects_on_player: Array[StatusEffect]
@export var item_data: ItemResource


func _ready() -> void:
	$Visual.texture = item_data.visual
	effects = item_data.effects
	effects_on_player = item_data.effects_on_player


func delete():
	await get_tree().create_timer(3).timeout
	queue_free()


func accuire(player):
	delete()
	$Sfx.play()
	$Area2D.queue_free()
	$Visual.visible = false
	if player.has_method("add_weapon_effect"):
		for effect in effects:
			print("accuired " + item_data.item_name)
			player.add_weapon_effect(effect)
	if player.has_method("apply_status"):
		for effect in effects_on_player:
			player.apply_status(effect)
	if player.has_method("display_item_accuired"):
		player.display_item_accuired(item_data.item_name, item_data.item_description)
