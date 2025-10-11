extends Node

class_name RLearn

const ESTATISTICA = "Estatisticas"
const PRIOR_KNOWLEDGE = "Conhecimento prévio"
const NONE = "Nenhum"

const RELATIONS = [
	{
		'habilitys' : Habilidades.SOCO,
		'learn_type' : NONE,
		'target' : [],
		'value':[]
	},
	{
		'habilitys' : Habilidades.ESGRIMA,
		'learn_type' : ESTATISTICA,
		'target' : ["MANEJO_DOWN","ESTOCADA","MANEJO_ABERTO_LATERAL","MANEJO_FECHADO_LATERAL"],
		'value':[10,10,10,10]
	},
	{
		'habilitys' : Habilidades.PANCADA,
		'learn_type' : NONE,
		'target' : [],
		'value':[]
	},
	{
		'habilitys' : Habilidades.CONTROLE_MAGICO,
		'learn_type' : NONE,
		'target' : [],
		'value':[]
	},
	{
		'habilitys' : Habilidades.ESFERA_MAGICA,
		'learn_type' : PRIOR_KNOWLEDGE,
		'target' : [Habilidades.CONTROLE_MAGICO],
		'value':[1]
	}
]

static func findRelation(skill_name):
	for rel in RELATIONS:
		if rel.habilitys.nome.to_lower() == skill_name.to_lower():
			return rel
	return null

static func hasRequirementToLearn(user,skill_name):
	var has_req : bool = true
	var skill = RLearn.findRelation(skill_name)
	
	if skill == null:
		return false
	
	if skill.learn_type == ESTATISTICA:
		has_req = verifyStatistic(user,skill)
	elif skill.learn_type == PRIOR_KNOWLEDGE:
		has_req = verifyHabilitys(user,skill)
	else:
		has_req = true
	
	return has_req

static func verifyStatistic(user,skill):
	for r in skill.target.size():
		if not user.estatisticas.hasThisCombatStatistic(Estatisticas.ESTATISTICAS_GROUP.DETALHADO,'agent',skill.target[r],skill.value[r]):
			return false
	return true

static func verifyHabilitys(user,skill):
	for r in skill.target.size():
		if not user.knowHabilidade(skill.target[r].nome):
			return false
	return true
