extends Node2D

class_name Spawner

var entity_race
var map

static func createSpawner(entity_race,map):
	var spawner = load("res://REMAKE/scenes/worldmap/SpawnArea.tscn").instantiate()
	spawner.setEntityRace(entity_race)
	spawner.setMap(map)
	return spawner

func _ready():
	$Timer.start(20)
	$Timer.connect("timeout",spawnEntity)

func setEntityRace(race):
	entity_race = race

func setMap(map):
	self.map = map

func spawnEntity():
	print(position)
	map.spawn_on_map(Entity.create_entity(entity_race), position.x,position.y)
