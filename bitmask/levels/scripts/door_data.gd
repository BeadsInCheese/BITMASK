extends Resource

class_name DoorData
enum door_direction { UP, DOWN, LEFT, RIGHT }

@export var door_dir: door_direction
static var direction_mapping = { door_direction.UP: Vector2i(0, -1), door_direction.DOWN: Vector2i(0, 1), door_direction.LEFT: Vector2i(-1, 0), door_direction.RIGHT: Vector2i(1, 0) }


func get_direction_vector() -> Vector2i:
	return direction_mapping[door_dir]
