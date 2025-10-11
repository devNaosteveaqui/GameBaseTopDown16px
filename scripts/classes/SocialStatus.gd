extends Node

class_name SocialStatus

enum RELATIONS {INIMIGO,INDIFERENTE,AMIGO}

var relations = {}

func addNewRelation(entityName):
	relations[entityName] = 0

func knowAbout(entityName):
	return relations.keys().has(entityName)

func upgradeRelation(entityName,value=1):
	relations[entityName] += value

func downgradeRelation(entityName,value=1):
	relations[entityName] -= value

func set_relation(entityName,value):
	relations[entityName] = value

func get_relation(entityName):
	if relations[entityName] < -20:
		return RELATIONS.INIMIGO
	elif relations[entityName] > 20:
		return RELATIONS.AMIGO
	else:
		return RELATIONS.INDIFERENTE
