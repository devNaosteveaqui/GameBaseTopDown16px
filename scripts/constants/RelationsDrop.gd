extends Node

class_name RDrop

const RELATIONS = [
	{
		'source' : Placeables.TRONCO,
		'drop' : [[1,Itens.TRONCO]]
	},
	{
		'source' : Placeables.PEDRA,
		'drop' : [[1,Itens.PEDRA]]
	},
	{
		'source' : Placeables.ARVORE,
		'drop' : [[5,Itens.TRONCO]]
	},
	{
		'source' : Placeables.ROCHA,
		'drop' : [[10,Itens.PEDRA]]
	},
	{
		'source' : Entities.GREENSLIME,
		'drop' : [[4,Itens.GOSMA_SLIME_VERDE]]
	},
	{
		'source' : Entities.HUMAN,
		'drop' : [[1,Itens.ESPADA_MADEIRA]]
	},
	{
		'source' : Placeables.BLOCK_GREENSLIME,
		'drop' : [[1,Itens.BLOCK_GREENSLIME]]
	}
]
static func findRelation(source):
	for rel in RELATIONS:
		if rel.source.nome == source.nome:
			return rel.drop
	return null
