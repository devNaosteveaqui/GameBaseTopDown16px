extends Node2D

class_name WorldTileMap

@warning_ignore("unused_signal")
signal map_generated

@export var world_map : Array[TileMapLayer]
@export var world_modfiers : Dictionary = {}
@export var map : Array
@export var map_resources : Array
@export var map_spawners : Dictionary

var world_selected = WorldsConfig.WORLD0
var generator = TerrainGenerate.new()

func _ready():
	GameConfig.WorldEntitys = $DinamicsObjects
	generate_world()
	
	#render(map,Rect2(-32,-32,64,64),map_resources)
	
	#spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,self), 0,0)
	var player : Entity = PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall)
	spawn_on_map(player,0,0)
	
func render(tiles:Array,area:Rect2,placeables:Array=map_resources):
	@warning_ignore("integer_division")
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var p_end = ( (area.position.x+area.size.x-1) + Game.MAP_WIDTH/2)  + ( (area.position.y+area.size.y-1) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var atlas_coord : Vector2i
	var p = -1
	var ktmp = 0
	var area_size = area.size.x*area.size.y
	var init_tile = tiles[p_start]
	var last_tile = tiles[p_end]
	
	#var only_one : bool = false
	
	#SPAWN DOS TILES
	for i in area_size:
		@warning_ignore("integer_division")
		p =( (area.position.x + (int(i) % int(area.size.x)) ) + Game.MAP_WIDTH/2)  + ( (area.position.y + int(i)/int(area.size.y) ) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
		
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		
		for layer in 4:
			atlas_coord.x = tiles[p].atlas[layer].x
			atlas_coord.y = tiles[p].atlas[layer].y
			world_map[layer].set_cell(pos,tiles[p].ids[layer],atlas_coord,tiles[p].alternative_id[layer])
			
	
	
	# SPAWN DOS PLACEABLES
	if placeables.size() > 0:
		for i in area_size:
			@warning_ignore("integer_division")
			p =( (area.position.x + (int(i) % int(area.size.x)) ) + Game.MAP_WIDTH/2)  + ( (area.position.y + int(i)/int(area.size.y) ) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
			if placeables[p] != null && ((placeables[p].x >= init_tile.x && placeables[p].x <= last_tile.x)&&(placeables[p].y >= init_tile.y && placeables[p].y <= last_tile.y)):
				#if only_one :
					#continue
				#only_one = true
				var mod_key = "modk_pr_x"+str(placeables[p].x)+"y"+str(placeables[p].y)
				if !world_modfiers.keys().has(mod_key):
					world_modfiers[mod_key] = true
					spawn_on_map(Placeable.create_placeable(placeables[p].type), placeables[p].x*32 + 16,placeables[p].y*32 +16)
					ktmp = ktmp+1
					#await get_tree().create_timer(0.05).timeout
	
	# SPAWN SPAWNERS
	for k in map_spawners.keys():
		var xy = k.split('_')
		#if (int(xy[0]) >= init_tile.x and int(xy[0]) <= last_tile.x) and (int(xy[1]) >= init_tile.y and int(xy[1]) <= last_tile.y):
		if !has_this_object(k):
			var spawner = Spawner.create_spawner(map_spawners[k],self)
			spawner.name = k
			#spawn_on_map(spawner,randi_range(-256,256),randi_range(-256,256))
			spawn_on_map(spawner,int(xy[0]),int(xy[1]))
			#await get_tree().create_timer(0.05).timeout
	

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
	@warning_ignore("integer_division")
	generator.generate_floor(self,Game.MAP_WIDTH,Game.MAP_HEIGTH,-Game.MAP_WIDTH/2,-Game.MAP_HEIGTH/2)
	generator.generate_natural_spawners(self)
	generator.generate_nature(self)

static func spawn_on_map(e,x,y):
	e.set_position_on_world(x,y)
	spawn_on_world(e)

func is_free(x,y):
	var obj_on_world = GameConfig.get_objects_on_world_list()
	for e in obj_on_world:
		if Rect2(Vector2(x,y),Vector2(16,16)).intersection(Rect2(e.position,Vector2(16,16))):
			return false
	return true

func has_this_object(nome):
	return GameConfig.has_this_object_on_world(nome)

static func spawn_on_world(obj):
	if obj is Entity:
		var obj_on_world = GameConfig.get_objects_on_world_list()
		for e in obj_on_world:
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
	GameConfig.place_on_world(obj)

func load_map(rect:Rect2):
	if !has_map_generated():
		generate_world()
	
	var rect_in_tiles : Rect2 = Rect2(0,0,0,0)
	rect_in_tiles.position.x = rect.position.x/32
	rect_in_tiles.position.y = rect.position.y/32
	rect_in_tiles.size.x = rect.size.x/32
	rect_in_tiles.size.y = rect.size.y/32
	render(map,rect_in_tiles,map_resources)

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
		#if tile_id >= 0 and tile_id < 3:
		var tile_alt = world_map[TerrainGenerate.TOPSOIL].get_cell_alternative_tile(pos)
		if tile_id == 1 and tile_alt != 5 or tile_alt != 2:
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
