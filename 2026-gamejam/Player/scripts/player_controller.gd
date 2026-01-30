extends CharacterBody2D
@export var speed=2
@export var shoot_offset=2
@export var bullet_base:PackedScene

func shoot(direction:Vector2):
	var bullet=bullet_base.instantiate()
	bullet.global_position=global_position+direction*shoot_offset
	bullet.direction=direction
	get_tree().root.add_child(bullet)

	print(bullet.global_position)


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot_mouse"):
		shoot(-(global_position-get_global_mouse_position()).normalized())
	if Input.is_action_pressed("ui_down"):
		velocity.y+=1
	if Input.is_action_pressed("ui_up"):
		velocity.y-=1
	if Input.is_action_pressed("ui_left"):
		velocity.x-=1
	if Input.is_action_pressed("ui_right"):
		velocity.x+=1
	
	move_and_collide(velocity.normalized()*speed)
	velocity=Vector2(0,0)
