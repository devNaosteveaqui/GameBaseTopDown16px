extends Node2D

class_name Spawner

var entity_type
var map
var countSpawns : int = 0

static func createSpawner(entity_type,map):
	var spawner = load("res://scenes/worldmap/SpawnArea.tscn").instantiate()
	spawner.set_entity_type(entity_type)
	spawner.set_map(map)
	return spawner

func _ready():
	$Timer.start(5)
	$Timer.connect("timeout",spawnEntity)

func set_entity_type(entity_type):
	self.entity_type = entity_type

func set_map(map):
	self.map = map

func spawnEntity():
	if countSpawns < 2:
		var e : Entity = Entity.create_entity(entity_type)
		e.connect("deathCharacter",desSpawn)
		var spawnPoint : Vector2 = Vector2(position.x,position.y)
		spawnPoint.x += randi_range(-48,48)
		spawnPoint.y += randi_range(-48,48)
		map.spawn_on_map(e, spawnPoint.x,spawnPoint.y)
		countSpawns += 1

func desSpawn():
	countSpawns -= 1
