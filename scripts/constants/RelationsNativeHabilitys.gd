extends Node

class_name RNativeHabilitys

const RELATIONS = [
	{
		'entity' : Entities.HUMAN,
		'habilitys' : [Habilidades.SOCO]
	},
	{
		'entity' : Entities.GREENSLIME,
		'habilitys' : [Habilidades.PANCADA]
	}
]

static func findRelation(entity_type):
	for rel in RELATIONS:
		if rel.entity.nome == entity_type.nome:
			return rel.habilitys
	return null
