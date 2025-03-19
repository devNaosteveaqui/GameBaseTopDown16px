extends Node2D

class_name WorldTileMap

@warning_ignore("unused_signal")
signal map_generated

@export var world_map : Array[TileMapLayer]
@export var world_modfiers : Dictionary = {}
@export var map : Array
@export var map_resources : Array
@export var map_spawners : Dictionary
var generator = TerrainGenerate.new()

func _ready():
	GameConfig.WorldEntitys = $DinamicsObjects
	generate_world()
	
	#render(map,Rect2(-32,-32,64,64),map_resources)
	
	#spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,self), 0,0)
	var player : Entity = PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall)
	player.deathCharacter.connect(spawn_on_map.bind(PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall,{}),0,0))
	spawn_on_map(player,0,0)
	
	print("READY")

func render(tiles:Array,area:Rect2,placeables:Array=map_resources):
	@warning_ignore("integer_division")
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var p_end = ( (area.position.x+area.size.x-1) + Game.MAP_WIDTH/2)  + ( (area.position.y+area.size.y-1) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var p = -1
	var ktmp = 0
	var area_size = area.size.x*area.size.y
	var init_tile = tiles[p_start]
	var last_tile = tiles[p_end]
	
	for i in area_size:
		@warning_ignore("integer_division")
		p =( (area.position.x + (int(i) % int(area.size.x)) ) + Game.MAP_WIDTH/2)  + ( (area.position.y + int(i)/int(area.size.y) ) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
		
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		
		#SPAWN DOS TILES
		for layer in 4:
			world_map[layer].set_cell(pos,tiles[p].ids[layer],Vector2(0,0),0)
		
		# SPAWN DOS PLACEABLES
		
		# METODO LENTO: Não permite o load dos tiles por completo
		#for j in placeables.size():
			#if placeables[j] != null:
				#if placeables[j].x == pos.x && placeables[j].y == pos.y:
					#var mod_key = "modk_pr_x"+str(placeables[j].x)+"y"+str(placeables[j].y)
					#if !world_modfiers.keys().has(mod_key):
						#world_modfiers[mod_key] = true
						#spawn_on_map(Placeable.createPlaceable(placeables[j].type), placeables[j].x,placeables[j].y)
						#ktmp = ktmp+1
		
		# METODO RAPIDO: porém os placeables são colocados no lugar errado
		
		if placeables[p] != null && ((placeables[p].x >= init_tile.x && placeables[p].x <= last_tile.x)&&(placeables[p].y >= init_tile.y && placeables[p].y <= last_tile.y)):
			var mod_key = "modk_pr_x"+str(placeables[p].x)+"y"+str(placeables[p].y)
			if !world_modfiers.keys().has(mod_key):
				world_modfiers[mod_key] = true
				#print("Placeable ( ",placeables[i].x, " , " , placeables[i].y," | ",placeables[i].x*16, " , " , placeables[i].y*16," )")
				spawn_on_map(Placeable.createPlaceable(placeables[p].type), placeables[p].x*32 + 16,placeables[p].y*32 +16)
				ktmp = ktmp+1
		
		# SPAWN SPAWNERS
	for k in map_spawners.keys():
		if !has_this_object(k):
			var xy = k.split('_')
			var spawner = Spawner.createSpawner(map_spawners[k],self)
			spawner.name = k
			spawn_on_map(spawner,int(xy[0]),int(xy[1]))
	print("RENDER")

func unrender(tiles:Array,area:Rect2):
	@warning_ignore("integer_division")
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var p = -1
	for i in area.size.x*area.size.y:
		@warning_ignore("integer_division")
		p = p_start + (int(i) % int(area.size.x)) + (Game.MAP_WIDTH)*(int(i)/int(area.size.y))
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		for layer in 4:
			world_map[layer].set_cell(pos,-1,Vector2(0,0),0)

func generate_world():
	print("Gerando")
	@warning_ignore("integer_division")
	generator.generate_floor(self,Game.MAP_WIDTH,Game.MAP_HEIGTH,-Game.MAP_WIDTH/2,-Game.MAP_HEIGTH/2)
	generator.generate_natural_spawners(self)
	generator.generate_nature(self)

func spawn_on_map(e,x,y):
	e.position = Vector2(x,y)
	placeOnWorld(e)

func is_free(x,y):
	for e in GameConfig.WorldEntitys.get_children():
		if Rect2(Vector2(x,y),Vector2(16,16)).intersection(Rect2(e.position,Vector2(16,16))):
			return false
	return true

func has_this_object(nome):
	return GameConfig.WorldEntitys.get_node_or_null(nome)

func placeOnWorld(obj):
	if obj is Entity:
		for e in GameConfig.WorldEntitys.get_children():
			if e is Entity:
				if e.position.distance_to(obj.position) < 8:
					var distX = e.position.x - obj.position.x
					var distY = e.position.y - obj.position.y
					if abs(distX) > abs(distY):
						if distX == 0:
							obj.position.x = obj.position.x + 16*(randi()%3 - 1)
						else:
							obj.position.x = obj.position.x + 16*(distX/abs(distX))
					else:
						if distX == 0:
							obj.position.y = obj.position.y + 16*(randi()%3 - 1)
						else:
							obj.position.y = obj.position.y + 16*(distY/abs(distY))
	GameConfig.WorldEntitys.placeOnWorld(obj)

func load_map(rect:Rect2):
	if !has_map_generated():
		generate_world()
		print("GENERATED")
	
	var rect_in_tiles : Rect2 = Rect2(0,0,0,0)
	rect_in_tiles.position.x = rect.position.x/32
	rect_in_tiles.position.y = rect.position.y/32
	rect_in_tiles.size.x = rect.size.x/32
	rect_in_tiles.size.y = rect.size.y/32
	render(map,rect_in_tiles,map_resources)
	print("LOADED : ", rect)

func unload_map(rect:Rect2):
	var rect_in_tiles : Rect2 = Rect2(0,0,0,0)
	rect_in_tiles.position.x = rect.position.x/32
	rect_in_tiles.position.y = rect.position.y/32
	rect_in_tiles.size.x = rect.size.x/32
	rect_in_tiles.size.y = rect.size.y/32
	unrender(map,rect_in_tiles)

func floor_at(pos:Vector2):
	var tile_id = world_map[TerrainGenerate.FLOOR].get_cell_source_id(pos)
	if tile_id == -1:
		tile_id = world_map[TerrainGenerate.TOPSOIL].get_cell_source_id(pos)
	else:
		if tile_id >= 0 and tile_id < 3:
			return TerrainGenerate.TILE_TYPE.GRASS
		else:
			return TerrainGenerate.TILE_TYPE.ROCK
	if tile_id == -1:
		tile_id = world_map[TerrainGenerate.UNDERLYING].get_cell_source_id(pos)
	else:
		return TerrainGenerate.TILE_TYPE.DIRT
	if tile_id == -1:
		tile_id = world_map[TerrainGenerate.ROCKY].get_cell_source_id(pos)
	else:
		return TerrainGenerate.TILE_TYPE.SAND
	return -1

func has_map_generated():
	if map != null:
		if map.size() > 0:
			return true
	return false
