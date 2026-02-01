class_name stats
extends Resource

@export var max_hp: int
#@export var bullet_list
#@export var bullet_lvl
@export var ce: int
@export var ce_regen: int
@export var speed: float
@export var accel: float = 1
@export var texture: Texture2D
@export var bullet_dmg: float
@export_enum("Ranged", "Melee", "Stationary")
var behavior_type: int
@export var required_to_destroy: bool = false

@export var loot_table: LootTable

#func _init(a = 10,b = 10,r = 10,s=100):
#max_hp = a
#ce = b
#ce_regen = r
#speed = s
