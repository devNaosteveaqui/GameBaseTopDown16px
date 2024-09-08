extends Node2D

class_name Spawner

var entity_race
var map
var countSpawns : int = 0

static func createSpawner(entity_race,map):
	var spawner = load("res://scenes/worldmap/SpawnArea.tscn").instantiate()
	spawner.setEntityRace(entity_race)
	spawner.setMap(map)
	return spawner

func _ready():
	$Timer.start(5)
	$Timer.connect("timeout",spawnEntity)

func setEntityRace(race):
	entity_race = race

func setMap(map):
	self.map = map

func spawnEntity():
	if countSpawns < 2:
		var e : Entity = Entity.create_entity(entity_race)
		e.connect("deathCharacter",desSpawn)
		var spawnPoint : Vector2 = Vector2(position.x,position.y)
		spawnPoint.x += randi_range(-48,48)
		spawnPoint.y += randi_range(-48,48)
		map.spawn_on_map(e, spawnPoint.x,spawnPoint.y)
		countSpawns += 1

func desSpawn():
	countSpawns -= 1
