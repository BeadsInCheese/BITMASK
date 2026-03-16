extends Node2D

class Chunk:
	var area: AreaData
	var pos: Vector2i


	func _init(area: AreaData, pos: Vector2i) -> void:
		self.area = area
		self.pos = pos


var level: Array[Chunk]
@export var areas: Array[AreaData]
@export var starting_room: AreaData
@export var box_size: float


func AABB_test(a: Vector2, a_size: Vector2, b: Vector2, b_size: Vector2):
	var x_intersect: bool = b.x + b_size.x > a.x && b.x < a.x + a_size.x
	var y_intersect: bool = b.y + b_size.y > a.y && b.y < a.y + a_size.y
	return x_intersect && y_intersect


func validate(chunk: Chunk):
	if chunk.pos.y < 0 or chunk.pos.y > 100:
		return false
	if chunk.pos.x < 0 or chunk.pos.x > 100:
		return false
	for area in level:
		if AABB_test(area.pos, area.area.area_size, chunk.pos, chunk.area.area_size):
			return false
	return true


func get_neighbouring_room(door_pos, door_dir):
	for level_chunk in level:
		if level_chunk.pos == door_pos + door_dir:
			return level_chunk
	return null


func has_matching_door(neghbour, dir):
	if neghbour == null:
		return true
	for neighbour_door in neghbour.area.doors:
		if neighbour_door.get_direction_vector() == dir:
			return true
	return false


func validate_doors(chunk):
	for direction in DoorData.direction_mapping.values():
		var neighbour = get_neighbouring_room(chunk.pos, direction)
		if neighbour == null:
			continue
		if has_matching_door(chunk, direction):
			if !has_matching_door(neighbour, -direction):
				return false
		if has_matching_door(neighbour, -direction):
			if !has_matching_door(chunk, direction):
				return false
	return true


func create_room(door_pos, door_dir):
	if get_neighbouring_room(door_pos, door_dir) != null:
		return true

	areas.shuffle()
	for area in areas:
		for door in area.doors:
			if door.get_direction_vector() == -door_dir:
				var chunk = Chunk.new(area, door_pos + door_dir)
				if validate(chunk) && validate_doors(chunk):
					print("created room at " + str(chunk.pos))

					level.append(chunk)
					var door_failed = false
					for chunk_door in chunk.area.doors:
						if !await create_room(chunk.pos, chunk_door.get_direction_vector()):
							level.pop_back()
							door_failed = true
							print("room is unfit for tile")
							break
					if door_failed:
						break
					queue_redraw()
					await get_tree().process_frame
					return true

	printerr("room generation failed")
	return false


func generate():
	areas.shuffle()
	var chunk = Chunk.new(starting_room, Vector2i(50, 50))
	level.append(chunk)
	for door in starting_room.doors:
		print("creating room...")
		await create_room(Vector2i(50, 50), door.get_direction_vector())


func draw():
	var output = ""
	var tiles = []
	for i in 100:
		for j in 100:
			var found = false
			for chunk in level:
				if AABB_test(Vector2i(i, j), Vector2i(1, 1), chunk.pos, chunk.area.area_size):
					output += "X"
					found = true
					tiles.append([Vector2i(i, j), chunk.pos])
					break
			if !found:
				output += "0"
		output += "\n"
	print(output)
	print(tiles)
	print(level.size())


var draw_size = 10
var draw_size_half = draw_size / 2


func _draw():
	for i in 100:
		for j in 100:
			var found = false
			for chunk in level:
				if AABB_test(Vector2i(i, j), Vector2i(1, 1), chunk.pos, chunk.area.area_size):
					draw_rect(Rect2(i * draw_size, j * draw_size, draw_size, draw_size), Color.GREEN)
					for door in chunk.area.doors:
						var center = Vector2(i * draw_size + draw_size_half, j * draw_size + draw_size_half)
						draw_line(center, center + draw_size_half * Vector2(door.get_direction_vector()), Color.RED)


func start():
	while true:
		await generate()

		await get_tree().process_frame
		queue_redraw()
		level.clear()


func _ready() -> void:
	call_deferred("start")
