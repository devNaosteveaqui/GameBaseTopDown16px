extends Node

class_name RSpawns

const RELATIONS = [
	{
		'entity' : Entities.GREENSLIME,
		'max_count' : 3,
		'biomes':[]
	},
	{
		'entity' : Entities.BROWNCOW,
		'max_count' : 2,
		'biomes':[]
	}
]

static func findRelation(tile_type):
	for rel in RELATIONS:
		if rel.entity == tile_type:
			return rel.duplicate(true)
	return null

static func sort_spawn():
	return RELATIONS[randi()%(RELATIONS.size())].duplicate(true)
