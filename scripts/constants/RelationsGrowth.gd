extends Node

class_name RGrowth

const RELATIONS = [
	{
		"root":Placeables.MUDA_DE_ARVORE,
		"growth":Placeables.ARVORE
	}
]

static func findRelation(root):
	for n in RELATIONS:
		if n.root.nome == root.nome:
			return n.growth
	return null
