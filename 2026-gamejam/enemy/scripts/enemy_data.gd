class_name stats
extends Resource

@export var max_hp: int
#@export var bullet_list
#@export var bullet_lvl
@export var ce: int
@export var ce_regen: int
@export var speed: float
@export var texture: Texture2D
@export_enum("Target player", "Random paths", "Stationary")
var behavior_type: int
@export var required_to_destroy: bool = false

@export var loot_table: LootTable

#func _init(a = 10,b = 10,r = 10,s=100):
#max_hp = a
#ce = b
#ce_regen = r
#speed = s
