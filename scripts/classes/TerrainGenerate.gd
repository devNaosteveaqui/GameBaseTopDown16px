extends Node

class_name TerrainGenerate

enum TILE_TYPE {NONE,GRASS,ROCK,DIRT,SAND,MATRIX}
enum LAYER_TILES {ROCKY,UNDERLYING,TOPSOIL,FLOOR}

const ROCKY = 0
const UNDERLYING = 1
const TOPSOIL = 2
const FLOOR = 3

var global_k_generate : Dictionary = {
	'pedra' : 0.2,
	'tronco' : 0.3
}
var floor_k_generate : Dictionary = {
	'grass' : 0.16,
	'rock' : 0.08
}
func create_geographic():
	#var geographic : Dictionary = {
		#'count_oceanos' : randi()%10,
		#'count_continentes' : randi()%14,
		#'flags_especiais': {
			#'congelado' : randi()%2,
			#'flutuante' : randi()%2,
			#'subterraneo' : randi()%2,
			#'submersso' : randi()%2
		#},
		#'continente_congelado' : randi()%2,
		#'continente_flutuante' : randi()%2,
		#'continente_subterraneo' : randi()%2
	#}
	pass

func generate_floor(tilemap:WorldTileMap,width,heigth,offset_x = 0, offset_y = 0):
	var tilesMap = []
	tilesMap.resize(width*heigth)
	
	for i in width*heigth:
		tilesMap[i] = {
			'x' : i%width+offset_x,
			'y' : i/heigth+offset_y,
			'atlas' : [
				{'x':0,'y':-1},
				{'x':0,'y':-1},
				{'x':0,'y':-1},
				{'x':0,'y':-1},
				{'x':0,'y':-1},
				{'x':0,'y':-1},
			],
			'ids' : [-1,-1,-1,-1,-1,-1],
			'alternative_id' : [-1,-1,-1,-1,-1,-1]
		}
		#var tile_sorted = randi()%6 - 1
		#tilesMap[i].ids[FLOOR] = tile_sorted# if (tile_sorted > -1 and randi()%10 > 2) else -1 #randi()%4
		#tilesMap[i].ids[TOPSOIL] = 0
		#tilesMap[i].ids[UNDERLYING] = 0
		
		var tile_alternative = randi()%6 - 1
		tilesMap[i].ids[FLOOR] = 1
		tilesMap[i].atlas[FLOOR].x = tile_alternative
		tilesMap[i].atlas[FLOOR].y = 0
		tilesMap[i].alternative_id[FLOOR] = (5 - tile_alternative) if tile_alternative != -1 else (-1)
		tilesMap[i].ids[TOPSOIL] = 2
		tilesMap[i].atlas[TOPSOIL].y = 1
		tilesMap[i].alternative_id[TOPSOIL] = 0
		tilesMap[i].ids[UNDERLYING] = 3
		tilesMap[i].atlas[UNDERLYING].y = 2
		tilesMap[i].alternative_id[UNDERLYING] = 0
		
	tilemap.map = tilesMap

func generate_natural_spawners(tilemap:WorldTileMap):
	
	#tilemap.spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,tilemap),0,0)
	var natural_spawners : Dictionary = {}
	var wide_size : int = tilemap.world_selected.wide_spawn_size
	var map_limits : Dictionary = {
		'xi':(-wide_size)*Game.MAP_WIDTH,
		'xf':(wide_size)*Game.MAP_WIDTH,
		'yi':(-wide_size)*Game.MAP_HEIGTH,
		'yf':(wide_size)*Game.MAP_HEIGTH
	}
	for i in tilemap.world_selected.spawner_count:
		var posit = str(randi_range(map_limits.xi,map_limits.xf)) + "_" + str(randi_range(map_limits.yi,map_limits.yf))
		natural_spawners[posit] = RSpawns.sort_spawn().entity
		#print("generate spawner - ",posit)
	tilemap.map_spawners = natural_spawners.duplicate(true)
		

func floor_on_suface(tile):
	#Set Layer Floor
	var t = tile.ids[FLOOR]
	if t == -1:
		t = tile.ids[TOPSOIL]
	else:
		if t >= 0 && t < 3:
			return TILE_TYPE.GRASS
		else:
			return TILE_TYPE.ROCK
	
	#Changed to Layer Topsoil
	if t == -1:
		t = tile.ids[UNDERLYING]
	else:
		return TILE_TYPE.DIRT
	
	#Changed to layer Underlying
	if t == -1:
		t = tile.ids[ROCKY]
	else:
		return TILE_TYPE.SAND
	
	#Changed to layer Rocky
	if t == -1:
		return TILE_TYPE.NONE
	else:
		return TILE_TYPE.MATRIX

func generate_nature(tilemap:WorldTileMap,density:float):
	# ERR - A distribuição dos valores parece estar errada
	var nature_obj = []
	nature_obj.resize(tilemap.map.size())
	var count = 0
	var farway_position = Vector2(tilemap.map[0].x,tilemap.map[0].y)
	for t in tilemap.map.size():
		var ftype : TILE_TYPE = floor_on_suface(tilemap.map[t])
		
		var possibilitys = RChanceSpawn.findPossibilitysSpawn(ftype)
		
		if possibilitys.size() < 1:
			continue
		
		
		var value_sorted = randf()
		for p in possibilitys.size():
			var tile = possibilitys[p].keys()[0]
			value_sorted = value_sorted - possibilitys[p][tile]*density
			
			if value_sorted < 0 and nature_obj[t] == null:
				count = count + 1
				farway_position = Vector2(tilemap.map[t].x,tilemap.map[t].x) if farway_position.x < tilemap.map[t].x and farway_position.y < tilemap.map[t].y else farway_position
				nature_obj[t] = {'type':tile,'x':tilemap.map[t].x,'y':tilemap.map[t].y}
				#ERRO GERAÇÃO
		#match ftype:
			#TILE_TYPE.GRASS:
				#if randi()%10 > 6:
					#nature_obj[t] = {'type':Placeables.ARVORE,'x':tilemap.map[t].x,'y':tilemap.map[t].y}
					#
			#TILE_TYPE.ROCK:
				#if randi()%10 > 7:
					#nature_obj[t] = {'type':Placeables.ROCHA,'x':tilemap.map[t].x,'y':tilemap.map[t].y}
			#_:
				#pass
	#print(nature_obj.size(), " - ", count , " - ", farway_position)
	tilemap.map_resources = nature_obj.duplicate(true)

@warning_ignore("unused_parameter")
func generate_initial_npcs(tilemap:WorldTileMap):
	var npcs : Array = []
	
	return npcs
