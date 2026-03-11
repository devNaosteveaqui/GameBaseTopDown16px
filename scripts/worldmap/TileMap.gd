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

var map_in_generate : Dictionary
var map_in_generating : bool = false

func _ready():
	GameConfig.WorldEntitys = $DinamicsObjects
	generate_world()
	#render(map,Rect2(-32,-32,64,64),map_resources)
	#spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,self), 0,0)
	var player : Entity = PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall)
	spawn_on_map(player,0,0)

var count_max
var frames_interval = 6
var generate_rate = frames_interval
func _physics_process(delta: float) -> void:
	if map_in_generating:
		if generate_rate < 1:
			generate_rate = frames_interval
		if generate_rate == frames_interval:
			var count = count_max;
			for i in map_in_generate.size():
				if count < 1:
					break
				var key = map_in_generate.keys().pick_random()
				if map_in_generate[key].has("placeable_type"):
					spawn_placeable(map_in_generate[key]["placeable_type"],map_in_generate[key]["placeable_pos"])
				#print("Verificando se tem spawner ",map_in_generate[key])
				if map_in_generate[key].has("spawner_name"):
					spawn_spawner(map_in_generate[key]["spawner_name"],map_in_generate[key]["spawner_pos"])
				map_in_generate.erase(key)
				count = count - 1
		generate_rate = generate_rate - 1
		map_in_generating = !(map_in_generate.size() < 1)

func render(tiles:Array,area:Rect2,placeables:Array=map_resources):
	@warning_ignore("integer_division")
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var p_end = ( (area.position.x+area.size.x-1) + Game.MAP_WIDTH/2)  + ( (area.position.y+area.size.y-1) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var atlas_coord : Vector2i
	var p = -1
	var area_size = area.size.x*area.size.y
	var init_tile = tiles[p_start]
	var last_tile = tiles[p_end]
	
	var p_offset = ( area.position.x + Game.MAP_WIDTH/2)  + ( (area.position.y ) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var p_at
	#SPAWN DOS TILES
	for i in area_size:
		p_at = (int(i) % int(area.size.x)) + (int(i)/int(area.size.y))*Game.MAP_WIDTH
		@warning_ignore("integer_division")
		p = p_offset + p_at #( (area.position.x + (int(i) % int(area.size.x)) ) + Game.MAP_WIDTH/2)  + ( (area.position.y + int(i)/int(area.size.y) ) + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
		
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		for layer in 4:
			atlas_coord.x = tiles[p].atlas[layer].x
			atlas_coord.y = tiles[p].atlas[layer].y
			world_map[layer].set_cell(pos,tiles[p].ids[layer],atlas_coord,tiles[p].alternative_id[layer])
		
	#print("Init Tile : ",init_tile.x, ", ",init_tile.y)
	#print("Last Tile : ",last_tile.x, ", ",last_tile.y)
	
	# SPAWN DOS PLACEABLES
	#print(placeables.size())
	var farway_pos
	if placeables.size() > 0:
		for i in area_size:
			p_at = (int(i) % int(area.size.x)) + (int(i)/int(area.size.y))*Game.MAP_WIDTH
			@warning_ignore("integer_division")
			p = p_offset + p_at
			if placeables[p] != null && ((placeables[p].x >= init_tile.x && placeables[p].x <= last_tile.x)&&(placeables[p].y >= init_tile.y && placeables[p].y <= last_tile.y)):
				if farway_pos == null:
					farway_pos = Vector2(placeables[p].x,placeables[p].y)
				elif farway_pos.x < placeables[p].x and farway_pos.y < placeables[p].y:
					farway_pos = Vector2(placeables[p].x,placeables[p].y)
				#if only_one :
					#continue
				#only_one = true
				var mod_key = "modk_pr_x"+str(placeables[p].x)+"y"+str(placeables[p].y)
				if !world_modfiers.has(mod_key):
					world_modfiers[mod_key] = true
					map_in_generate[p_at] = {
						"id":p_at,
						"placeable_type":placeables[p].type,
						"placeable_pos":Vector2(placeables[p].x*32 +16,placeables[p].y*32 +16)#Vector2(placeables[p].x*32 + 16,placeables[p].y*32 +16)
					}
					#spawn_placeable(map_in_generate[p_at]["placeable_type"],map_in_generate[p_at]["placeable_pos"])
	#print("Placeable far way ",farway_pos)
	# SPAWN SPAWNERS
	for k in map_spawners.keys():
		var xy = k.split('_')
		#print("Spawner position : ",xy)
		if (int(xy[0]) >= init_tile.x*32 and int(xy[0]) <= last_tile.x*32) and (int(xy[1]) >= init_tile.y*32 and int(xy[1]) <= last_tile.y*32):
			if !has_this_object(k):
				p_at = (int(xy[0]) + int(xy[1]))*Game.MAP_WIDTH
				if map_in_generate.has(p_at):
					map_in_generate[p_at]["spawner_name"] = k
					map_in_generate[p_at]["spawner_pos"] = Vector2(int(xy[0]),int(xy[1]))
				else:
					map_in_generate[p_at] = {
						"id":p_at,
						"spawner_name": k,
						"spawner_pos": Vector2(int(xy[0]),int(xy[1]))
					}
				#spawn_spawner(map_in_generate[p_at]["spawner_name"],map_in_generate[p_at]["spawner_pos"])
	
	count_max = map_in_generate.keys().size()*0.1
	map_in_generating = true

func spawn_placeable(placeable_type,placeable_pos:Vector2):
	spawn_on_map(Placeable.create_placeable(placeable_type),placeable_pos.x,placeable_pos.y)

func spawn_spawner(spawner_name,spawner_pos:Vector2):
	var spawner = Spawner.create_spawner(map_spawners[spawner_name],self)
	spawner.name = spawner_name
	spawn_on_map(spawner,spawner_pos.x,spawner_pos.y)

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
	generator.generate_nature(self,0.45)

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
