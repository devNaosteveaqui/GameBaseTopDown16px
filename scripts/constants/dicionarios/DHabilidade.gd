extends Node

class_name Habilidades

const PHYSIC_SKILL = "fisico"
const MAGIC_SKILL = "magico" #Invocam magias para esse mundo
const THROWABLE = "throwable"

const EMPUNHAVEL_EQUIPED = "Empunhavel equipado"
const MAOS_LIVRES = "Mãos Livres"
const LEARNED_SKILL = "Aprendido habilidade"
const APRENDIDO_HABILIDADE = "Aprendido habilidade"
const REPETIDO_MOVIMENTOS = "Repetido movimentos"

const SOCO = {
	'nome' : "Soco",
	'type' : PHYSIC_SKILL,
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'passive' : false,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : [],
	'requisitos_learn' : [{'objective':MAOS_LIVRES}]
}
const ESGRIMA = {
	'nome' : "Esgrima",
	'type' : PHYSIC_SKILL,
	'born_effect' : [-2,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'passive' : true,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : [{'objective':EMPUNHAVEL_EQUIPED}]
}
const PANCADA = {
	'nome' : "Pancada",
	'type' : PHYSIC_SKILL,
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'passive' : false,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : []
}
const CONTROLE_MAGICO = {
	'nome' : "Controle Mágico",
	'type' : MAGIC_SKILL,
	'born_effect' : [0,0,0,0],
	'born_effect_consum' : [0,0,0,0],
	'passive' : true,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : []
}
const ESFERA_MAGICA = {
	'nome' : "Esfera Magica",
	'type' : MAGIC_SKILL,
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'passive' : false,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : [{'objective':LEARNED_SKILL,'target':CONTROLE_MAGICO}]
}
const COICE = {
	'nome' : "Coice",
	'type' : PHYSIC_SKILL,
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'passive' : false,
	'target_area' : false,
	'status_condition' : [],
	'requisitos_use' : [],
	'requisitos_learn' : [{'objective':MAOS_LIVRES}]
}
const habilidades_lista = {
	SOCO.nome : SOCO,
	ESGRIMA.nome : ESGRIMA,
	PANCADA.nome : PANCADA,
	CONTROLE_MAGICO.nome : CONTROLE_MAGICO,
	ESFERA_MAGICA.nome : ESFERA_MAGICA,
	COICE.nome : COICE
}
static func hasHabilityRequirementToUse(hab,entity:Entity):
	var hasReq : bool = true
	for r in hab.requisitos_use.size():
		if hab.requisitos_use[r].objective == EMPUNHAVEL_EQUIPED:
			if not entity.inventory.isWieldableItemEquiped():
				return false #Não é um item empunhavel
		if hab.requisitos_use[r].objective == MAOS_LIVRES:
			if not entity.inventory.isHandsFree():
				return false #Mãos não estão livres
		if hab.requisitos_use[r].objective == LEARNED_SKILL:
			if not entity.knowHabilidade(hab.requisitos_use[r].target.nome):
				return false
	return hasReq
