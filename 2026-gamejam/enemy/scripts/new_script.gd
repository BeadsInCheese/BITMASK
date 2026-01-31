class_name stats
extends Resource

@export var hp : int
#@export var bullet_list
#@export var bullet_lvl
@export var ce : int
@export var ce_regen : int
@export var speed : float

func _init(a,b,r,s):
	hp = a
	ce = b
	ce_regen = r
	speed = s
