extends Node

class_name RExtract

const RELATIONS = [
	{
		'source' : Entities.BROWNCOW,
		'extract' : [[1,Itens.LEITE,"Balde cheio com leite."]]
	}
]
static func findRelation(source):
	if source.size() < 1:
		return null
	for rel in RELATIONS:
		if rel.source.nome == source.nome:
			return { 'extract' : rel.extract.duplicate(true)}
	return null
