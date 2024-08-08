extends Node2D

@onready var map = $TileMap
var generator = TerrainGenerate.new()


func _ready():
	#var start_at = Time.get_ticks_msec()
	var tiles = generator.generate_floor(Game.MAP_WIDTH,Game.MAP_HEIGTH,Game.MAP_WIDTH/2,Game.MAP_HEIGTH/2)
	#var dt = Time.get_ticks_msec() - start_at
	#print(dt)
	map.render(tiles)
	
	map.spawn_on_map(Spawner.createSpawner(Entities.HUMAN,map), 100,100)
	
	
	#print(Time.get_ticks_msec() - start_at - dt)
	



