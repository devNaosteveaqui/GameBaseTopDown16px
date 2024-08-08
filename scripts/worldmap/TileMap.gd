extends TileMap

func render(tiles:Array):
	var pos : Vector2
	for i in tiles.size():
		pos.x = tiles[i].x
		pos.y = tiles[i].y
		for layer in 5:
			set_cell(layer,pos,tiles[i].ids[layer],Vector2(0,0),0)

func spawn_on_map(e,x,y):
	e.position = Vector2(x,y)
	$Entities.add_child(e)
	

func is_free(x,y):
	for e in $Entities.get_children():
		if Rect2(Vector2(x,y),Vector2(16,16)).intersection(Rect2(e.position,Vector2(16,16))):
			return false
	return true
