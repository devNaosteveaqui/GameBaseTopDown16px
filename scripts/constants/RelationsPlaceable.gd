extends Node

class_name RPlaceable

const RELATIONS = [
	{
		'source' : Itens.TRONCO,
		'placeable' : Placeables.TRONCO
	},
	{
		'source' : Itens.PEDRA,
		'placeable' : Placeables.PEDRA
	},
	{
		'source' : Itens.BLOCK_GREENSLIME,
		'placeable' : Placeables.BLOCK_GREENSLIME
	}
]

static func findRelation(source):
	for rel in RELATIONS:
		if rel.source.nome == source.nome:
			return rel.placeable
	return null

