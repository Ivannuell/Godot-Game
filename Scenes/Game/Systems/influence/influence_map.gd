class_name InfluenceMap
extends Node

var width
var height
var cell_size

var grid = []

func _init(map_width:int, map_height:int, size:int):
	width = map_width
	height = map_height
	cell_size = size

	grid.resize(width)

	for x in width:
		grid[x] = []
		grid[x].resize(height)

		for y in height:
			grid[x][y] = 0.0


func add_influence(world_pos:Vector2, value:float, radius:int):
	var cell = world_to_cell(world_pos)
	
	for x in range(cell.x - radius, cell.x + radius):
		for y in range(cell.y - radius, cell.y + radius):
			
			if x < 0 or y < 0 or x >= width or y >= height:
				continue
				
			var dist = cell.distance_to(Vector2(x,y))
			
			if dist > radius:
				continue
				
			var falloff = value / (1 + dist)
			
			grid[x][y] += falloff

func world_to_cell(pos:Vector2) -> Vector2:
	return Vector2(
		int(pos.x / cell_size),
		int(pos.y / cell_size)
	)
	

func clear():
	for x in width:
		for y in height:
			grid[x][y] = 0
