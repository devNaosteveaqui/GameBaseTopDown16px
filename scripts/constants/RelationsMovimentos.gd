extends Node

class_name RMovimentos

const RELATIONS = [
	{
		'moviment' : "SIMPLES_EXECUTION",
		'habilitys' : [Habilidades.SOCO]
	},
	{
		'moviment' : "BRUTE_EXECUTION",
		'habilitys' : [Habilidades.PANCADA]
	},
	{
		'moviment' : "MANEJO_DOWN",
		'habilitys' : [Habilidades.ESGRIMA]
	},
	{
		'moviment' : "ESTOCADA",
		'habilitys' : [Habilidades.ESGRIMA]
	},
	{
		'moviment' : "MANEJO_ABERTO_LATERAL",
		'habilitys' : [Habilidades.ESGRIMA]
	},
	{
		'moviment' : "MANEJO_FECHADO_LATERAL",
		'habilitys' : [Habilidades.ESGRIMA]
	}
]
static func findRelation(move):
	for rel in RELATIONS:
		if rel.moviment == move:
			return rel.habilitys
	return null
