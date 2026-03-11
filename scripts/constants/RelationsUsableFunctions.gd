extends Node

class_name RUseableFunc

enum FUNCTIONS {USE_LOQUID_CONTAINER,USE_CONSUMABLE}

const RELATIONS = {
	Itens.BALDE_MADEIRA : FUNCTIONS.USE_LOQUID_CONTAINER,
	Itens.BIFE_CRU : FUNCTIONS.USE_CONSUMABLE,
	Itens.FRUTA_VERMELHA : FUNCTIONS.USE_CONSUMABLE
}

static func findRelation(type):
	for rel in RELATIONS:
		if rel == type:
			return RELATIONS[rel]
	return null
