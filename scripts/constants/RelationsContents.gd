extends Node

class_name RContents

const RELATIONS = [
	{
		'container' : Itens.BALDE_MADEIRA,
		'content' : Itens.LEITE,
		'container_sprite' : "balde_madeira_leite.png"
	}
]
static func findRelation(container,content):
	for rel in RELATIONS:
		if rel.container.nome == container.nome:
			if rel.content.nome == content.nome:
				return { 'sprite' : rel.container_sprite}
	return null
