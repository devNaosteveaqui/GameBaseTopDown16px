extends Node2D

class_name Spawner

var entity_type
var map
var countSpawns : int = 0
var max_spawns_count : int

static func create_spawner(entityType,map_info:WorldTileMap):
	var spawner = load("res://scenes/worldmap/SpawnArea.tscn").instantiate()
	spawner.add_to_group(GameConfig.GROUP_SPAWNER)
	spawner.set_entity_type(entityType)
	spawner.set_map(map_info)
	spawner.max_spawns_count = RSpawns.findRelation(entityType).max_count
	GameConfig.create_object(spawner)
	return spawner

func _ready():
	$Timer.start(randi()%5+5)
	$Timer.connect("timeout",spawnEntity)

func set_entity_type(entityType):
	self.entity_type = entityType

func set_map(map_info):
	self.map = map_info

func set_position_on_world(x,y):
	self.position = Vector2(x,y)

func spawnEntity():
	if countSpawns < max_spawns_count:
		var e : Entity = Entity.create_entity(entity_type, false)
		e.connect("deathCharacter",desSpawn)
		var spawnPoint : Vector2 = Vector2(position.x,position.y)
		spawnPoint.x += randi_range(-48,48)
		spawnPoint.y += randi_range(-48,48)
		map.spawn_on_map(e, spawnPoint.x,spawnPoint.y)
		countSpawns += 1
#		await get_tree().create_timer(0.05).timeout

func desSpawn():
	countSpawns -= 1
