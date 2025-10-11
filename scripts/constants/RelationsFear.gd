extends Node

class_name RFears

const RELATIONS = [
	{
		'entity' : Entities.HUMAN,
		'fears' : [Entities.GREENSLIME],
		'hate' : []
	},
	{
		'entity' : Entities.GREENSLIME,
		'fears' : [],
		'hate':[Entities.HUMAN]
	},
	{
		'entity' : Entities.BROWNCOW,
		'fears' : [Entities.HUMAN],
		'hate' : [Entities.GREENSLIME]
	}
]

static func findFearRelation(entity_type):
	for rel in RELATIONS:
		if rel.entity.nome == entity_type.nome:
			return rel.fears
	return null

static func findHateRelation(entity_type):
	for rel in RELATIONS:
		if rel.entity.nome == entity_type.nome:
			return rel.hate
	return null
