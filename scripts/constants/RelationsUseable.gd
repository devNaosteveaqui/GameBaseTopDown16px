extends Node

class_name RUseable

const RELATIONS = [
	{
		'item':Itens.MACHADO_MADEIRA,
		'on_placeable':1,
		'on_entity':1,
		'on_item':0,
		'by_placeable':0,
		'by_entity':0,
		'by_item':1,
	},
	{
		'item':Itens.ESPADA_MADEIRA,
		'on_placeable':0,
		'on_entity':1,
		'on_item':0,
		'by_placeable':0,
		'by_entity':0,
		'by_item':1,
	}
]

static func findRelation(item):
	for r in RELATIONS:
		if r.item == item:
			return r
	return {
		'item':null,
		'on_placeable':0,
		'on_entity':0,
		'on_item':0,
		'by_placeable':0,
		'by_entity':0,
		'by_item':0,
	}
