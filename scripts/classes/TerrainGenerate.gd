extends Node

class_name TerrainGenerate

const ROCKY = 0
const UNDERLYING = 1
const TOPSOIL = 2
const FLOOR = 3

func generate_floor(width,heigth,offset_x = 0, offset_y = 0):
	var tilesMap = []
	tilesMap.resize(width*heigth)
	
	for i in width*heigth:
		tilesMap[i] = {
			'x' : i%width+offset_x,
			'y' : i/heigth+offset_y,
			'ids' : [-1,-1,-1,-1,-1,-1]
		}
		tilesMap[i].ids[FLOOR] = randi()%4
		tilesMap[i].ids[TOPSOIL] = 0
		tilesMap[i].ids[UNDERLYING] = 0
	
	return tilesMap
