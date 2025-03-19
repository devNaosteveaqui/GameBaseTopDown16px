extends Node

class_name RResourceSpawn

const RELATIONS = [
	{
		'placeable' : Placeables.ARVORE,
		'tile' : TerrainGenerate.TILE_TYPE.GRASS
	},
	{
		'placeable' : Placeables.ROCHA,
		'tile' : TerrainGenerate.TILE_TYPE.ROCK
	}
]

static func findRelation(tile_type):
	for rel in RELATIONS:
		if rel.tile == tile_type:
			return rel.placeable
	return null
