extends Node

class_name SistemaIndiomas

const LVL_MAX = 8

var lista : Dictionary

func hasIndioma(indioma):
	return lista.keys().has(indioma.to_lower())

func addIndioma(indioma:String,lvl:int = 1):
	var indioma_ref : Dictionary = {
		'indioma' : Indiomas.indiomas_lista[indioma],
		'lvl' : lvl
	}
	lista[indioma.to_lower()] = Indiomas.indiomas_lista[indioma]

func get_indioma_list():
	return lista

func hasAnyIndioma(indioma_list:Dictionary):
	for k in indioma_list.keys():
		if hasIndioma(k):
			return true
	return false
