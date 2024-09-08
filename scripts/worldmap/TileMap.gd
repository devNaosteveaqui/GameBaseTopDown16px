extends Node2D

@export var world_map : Array[TileMapLayer]

func _ready():
	GameConfig.WorldEntitys = $Entities

func render(tiles:Array):
	var pos : Vector2
	for i in tiles.size():
		pos.x = tiles[i].x
		pos.y = tiles[i].y
		for layer in 4:
			world_map[layer].set_cell(pos,tiles[i].ids[layer],Vector2(0,0),0)

func spawn_on_map(e,x,y):
	e.position = Vector2(x,y)
	placeOnWorld(e)

func is_free(x,y):
	for e in $Entities.get_children():
		if Rect2(Vector2(x,y),Vector2(16,16)).intersection(Rect2(e.position,Vector2(16,16))):
			return false
	return true

func placeOnWorld(obj):
	if obj is Entity:
		for e in $Entities.get_children():
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
	$Entities.add_child(obj)
