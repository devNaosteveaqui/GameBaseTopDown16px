extends Node

var list : Array = []

func create_list():
	add_item(Entities.HUMAN)
	add_item(Entities.BROWNCOW)
	add_item(Entities.GREENSLIME)
	return list

func add_item(entitie):
	var item_list : Dictionary = {
		'sprite' : entitie.animation,
		'nome' : entitie.nome,
		"energias":entitie.born_status,
		"dano a energia":entitie.born_effect,
		"drops":create_drop_list(RDrop.findRelation(entitie).drop_p)
	}
	
	list.append(item_list)

func create_drop_list(list):
	var new_list : Array = []
	for i in list:
		new_list.append("res://resources/itens/" + i[1].sprite)
	return new_list
