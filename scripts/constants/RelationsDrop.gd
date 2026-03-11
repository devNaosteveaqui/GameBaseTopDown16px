extends Node

class_name RDrop

enum SOURCE_SIZE {SMALL,MEDIUM,BIG,UNIQ,NOSIZE}

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
			'drop_hit' : [[1,Itens.LASCA_DE_MADEIRA],[5,Itens.FOLHA_DE_ARVORE],[3,Itens.GALHO_FRAGIL],[1,Itens.GALHO_GRANDE],[1,Itens.MUDA_DE_ARVORE]]
		}
	},
	{
		'source' : Placeables.ROCHA,
		'drop' : [[10,Itens.PEDRA]],
		'drop_by_stage' : {
			'flag_all' : false,
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
	},
	{
		'source' : Entities.BROWNCOW,
		'drop' : [[2,Itens.BIFE_CRU]],
		'drop_by_stage' : {
			'flag_all' : false
		}
	}
]
const RELATIONS_CHANCE = [
	
]
static func findRelation(source):
	if source.size() < 1:
		return null
	for rel in RELATIONS:
		if rel.source.nome == source.nome:
			return { 'drop_p' : rel.drop.duplicate(true), 'drop_s' : rel.drop_by_stage.duplicate(true)}
	return null
