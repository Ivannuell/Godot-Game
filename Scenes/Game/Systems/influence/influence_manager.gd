class_name InfluenceManager
extends Node2D

var timer = 0.0

var enemy_map : InfluenceMap
var ally_map : InfluenceMap
var resource_map : InfluenceMap

var enemy_units = []
var ally_units = []
var asteroids = []
var bases = []

func _ready():
	enemy_map = InfluenceMap.new(100,100,64)
	ally_map = InfluenceMap.new(100,100,64)
	resource_map = InfluenceMap.new(100,100,64)

func register_enemy(unit):
	if unit in enemy_units:
		return
	unit.connect('tree_exited', self, '_on_enemy_removed', [unit])
	enemy_units.append(unit)
func _on_enemy_removed(unit):
	enemy_units.erase(unit)

func register_ally(unit):
	ally_units.append(unit)

func register_resource(asteroid):
	if asteroid in asteroids:
		return

	asteroid.connect('tree_exited', self, "_on_asteroid_removed", [asteroid])
	asteroids.append(asteroid)
func _on_asteroid_removed(unit):
	asteroids.erase(unit)	


func rebuild_maps():
	enemy_map.clear()
	ally_map.clear()
	resource_map.clear()

	for unit in enemy_units:
		if not is_instance_valid(unit):
			enemy_map.erase(unit)
			continue
		enemy_map.add_influence(unit.position, 20, 6)

	for unit in ally_units:
		ally_map.add_influence(unit.position, 20, 6)

	for asteroid in asteroids:
		if not is_instance_valid(asteroid):
			asteroids.erase(asteroid)
			continue
		resource_map.add_influence(asteroid.global_position, 50, 4)

func _process(delta):
#	update()
	timer += delta
	if timer >= 1:
		rebuild_maps()
	
func _draw():
	pass
#	for x in enemy_map.width:
#		for y in enemy_map.height:
#
#			var value =  enemy_map.grid[x][y]
#
#			if value <= 0:
#				continue
#
#			draw_rect(
#				Rect2(x*64,y*64,64,64),
#				Color(1,0,0,value/50)
#			)
#	for x in resource_map.width:
#		for y in resource_map.height:
#
#			var value = resource_map.grid[x][y]
#
#			if value <= 0:
#				continue
#
#			draw_rect(
#				Rect2(x*64,y*64,64,64),
#				Color(0,0,1,value/50)
#			)
