extends Node

class_name RChanceSpawn

const RELATIONS = [
	{
		'placeable' : Placeables.ARVORE,
		'tile' : {
			TerrainGenerate.TILE_TYPE.GRASS : 0.8 # Difficult
		}
	},
	{
		'placeable' : Placeables.ROCHA,
		'tile' : {
			TerrainGenerate.TILE_TYPE.ROCK : 0.9
		}
	}
]

static func findRelation(tile_type:TerrainGenerate.TILE_TYPE):
	for rel in RELATIONS:
		if rel.tile.keys().has(tile_type):
			return rel.placeable
	return null

static func findPossibilitysSpawn(tile_type:TerrainGenerate.TILE_TYPE):
	var possibilitys : Array = []
	for rel in RELATIONS:
		if rel.tile.keys().has(tile_type):
			possibilitys.append({rel.placeable:rel.tile[tile_type]})
	return possibilitys
