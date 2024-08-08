extends Node

class_name TerrainGenerate

const UNDERFLOOR2 = 0
const UNDERFLOOR1 = 1
const FLOOR = 2
const OVERFLOOR1 = 3
const OVERFLOOR2 = 4

func generate_floor(width,heigth,offset_x = 0, offset_y = 0):
	var tilesMap = []
	tilesMap.resize(width*heigth)
	
	for i in width*heigth:
		tilesMap[i] = {
			'x' : i%width-offset_x,
			'y' : i/heigth-offset_y,
			'ids' : [-1,-1,-1,-1,-1]
		}
		tilesMap[i].ids[FLOOR] = randi()%4 + 2
		tilesMap[i].ids[UNDERFLOOR1] = 1
	
	return tilesMap
