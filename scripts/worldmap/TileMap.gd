extends Node2D

class_name WorldTileMap

signal map_generated

@export var world_map : Array[TileMapLayer]
@export var world_modfiers : Dictionary
@export var map : Array
var generator = TerrainGenerate.new()

func _ready():
	GameConfig.WorldEntitys = $DinamicsObjects
	generator.generate_floor(self,Game.MAP_WIDTH,Game.MAP_HEIGTH,-Game.MAP_WIDTH/2,-Game.MAP_HEIGTH/2)
	generator.generate_natural_spawners(self)
	
	render(map,Rect2(-32,-32,64,64))
	
	#spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,self), 0,0)
	var player : Entity = PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall)
	player.deathCharacter.connect(spawn_on_map.bind(PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall,{}),0,0))
	spawn_on_map(player,0,0)

func render(tiles:Array,area:Rect2):
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var p = -1
	for i in area.size.x*area.size.y:
		p = p_start + (int(i) % int(area.size.x)) + (Game.MAP_WIDTH)*(int(i)/int(area.size.y))
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		for layer in 4:
			world_map[layer].set_cell(pos,tiles[p].ids[layer],Vector2(0,0),0)

func unrender(tiles:Array,area:Rect2):
	var p_start = (area.position.x + Game.MAP_WIDTH/2) + (area.position.y + Game.MAP_HEIGTH/2)*Game.MAP_WIDTH
	var pos : Vector2
	var p = -1
	for i in area.size.x*area.size.y:
		p = p_start + (int(i) % int(area.size.x)) + (Game.MAP_WIDTH)*(int(i)/int(area.size.y))
		pos.x = tiles[p].x
		pos.y = tiles[p].y
		for layer in 4:
			world_map[layer].set_cell(pos,-1,Vector2(0,0),0)

func spawn_on_map(e,x,y):
	e.position = Vector2(x,y)
	placeOnWorld(e)

func is_free(x,y):
	for e in GameConfig.WorldEntitys.get_children():
		if Rect2(Vector2(x,y),Vector2(16,16)).intersection(Rect2(e.position,Vector2(16,16))):
			return false
	return true

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
	var rect_in_tiles : Rect2 = Rect2(0,0,0,0)
	rect_in_tiles.position.x = rect.position.x/32
	rect_in_tiles.position.y = rect.position.y/32
	rect_in_tiles.size.x = rect.size.x/32
	rect_in_tiles.size.y = rect.size.y/32
	render(map,rect_in_tiles)
	#print("Tilemap load map at ",rect)
	pass
func unload_map(rect:Rect2):
	#print("Tilemap unload map at ",rect)
	var rect_in_tiles : Rect2 = Rect2(0,0,0,0)
	rect_in_tiles.position.x = rect.position.x/32
	rect_in_tiles.position.y = rect.position.y/32
	rect_in_tiles.size.x = rect.size.x/32
	rect_in_tiles.size.y = rect.size.y/32
	unrender(map,rect_in_tiles)
	pass
