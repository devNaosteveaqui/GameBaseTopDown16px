extends Node

class_name TerrainGenerate

const ROCKY = 0
const UNDERLYING = 1
const TOPSOIL = 2
const FLOOR = 3

func generate_floor(tilemap:WorldTileMap,width,heigth,offset_x = 0, offset_y = 0):
	var tilesMap = []
	tilesMap.resize(width*heigth)
	
	for i in width*heigth:
		tilesMap[i] = {
			'x' : i%width+offset_x,
			'y' : i/heigth+offset_y,
			'ids' : [-1,-1,-1,-1,-1,-1]
		}
		tilesMap[i].ids[FLOOR] = randi()%6 - 1#randi()%4
		tilesMap[i].ids[TOPSOIL] = 0
		tilesMap[i].ids[UNDERLYING] = 0
	
	tilemap.map = tilesMap
func generate_natural_spawners(tilemap:WorldTileMap):
	tilemap.spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,tilemap),0,0)
	var natural_spawners : Array = []
	natural_spawners.append({
		'spawner':Spawner.createSpawner(Entities.GREENSLIME,tilemap),
		'x':0,
		'y':0
	})
	#return natural_spawners
func generate_nature(tilemap:WorldTileMap):
	var nature_obj : Array = []
	
	return nature_obj
func generate_initial_npcs(tilemap:WorldTileMap):
	var npcs : Array = []
	
	return npcs
