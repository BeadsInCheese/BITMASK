extends Node

@export var loot_table: LootTable

var available_items: Array[ItemResource]


func get_item():
	var index = randi() % available_items.size()
	var item = available_items[index]
	available_items.remove_at(index)
	return item
