extends Node

class_name SistemaHabilidades

var lista : Dictionary

func hasHabilidade(hab_name):
	return lista.keys().has(hab_name.to_lower())

func addHabilidade(hab_name:String):
	var nova_habilidade = Habilidade.createHabilidade(Habilidades.habilidades_lista[hab_name])
	lista[hab_name.to_lower()] = nova_habilidade

func get_habilidade(hab_name):
	return lista[hab_name.to_lower()]

func get_hability_with_req(trigger,list):
	if list == null:
		return null
	for h in list:
		if hasHabilidade(h.nome):
			var hab = get_habilidade(h.nome)
			if Habilidades.hasHabilityRequirementToUse(h,trigger):
				return hab
	return null
