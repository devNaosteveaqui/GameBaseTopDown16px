extends Node

class_name RDrop

const RELATIONS = [
	{
		'source' : Placeables.TRONCO,
		'drop' : [[1,Itens.TRONCO]],
		'drop_by_stage' : {
			'flag_all' : true
		}
	},
	{
		'source' : Placeables.PEDRA,
		'drop' : [[1,Itens.PEDRA]],
		'drop_by_stage' : {
			'flag_all' : true
		}
	},
	{
		'source' : Placeables.ARVORE,
		'drop' : [[5,Itens.TRONCO]],
		'drop_by_stage' : {
			'flag_all' : false,
			'drop_stage' : Itens.TRONCO,
			'drop_hit' : Itens.LASCA_DE_MADEIRA
		}
	},
	{
		'source' : Placeables.ROCHA,
		'drop' : [[10,Itens.PEDRA]],
		'drop_by_stage' : {
			'flag_all' : false,
			'drop_stage' : Itens.PEDRA,
			'drop_hit' : null
		}
	},
	{
		'source' : Entities.GREENSLIME,
		'drop' : [[4,Itens.GOSMA_SLIME_VERDE]],
		'drop_by_stage' : {
			'flag_all' : true
		}
	},
	{
		'source' : Entities.HUMAN,
		'drop' : [[1,Itens.ESPADA_MADEIRA]],
		'drop_by_stage' : {
			'flag_all' : true
		}
	},
	{
		'source' : Placeables.BLOCK_GREENSLIME,
		'drop' : [[1,Itens.BLOCK_GREENSLIME]],
		'drop_by_stage' : {
			'flag_all' : true
		}
	}
]
static func findRelation(source):
	for rel in RELATIONS:
		if rel.source.nome == source.nome:
			return rel.drop.duplicate(true)
	return null
