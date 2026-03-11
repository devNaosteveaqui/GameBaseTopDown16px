extends Node

var list : Array = []

func create_list():
	add_item(Itens.TRONCO)
	add_item(Itens.PEDRA)
	add_item(Itens.BALDE_MADEIRA)
	add_item(Itens.BIFE_CRU)
	add_item(Itens.BLOCK_GREENSLIME)
	add_item(Itens.CABECA_MACHADO_MADEIRA)
	add_item(Itens.CABO_MADEIRA)
	add_item(Itens.ESPADA_MADEIRA)
	add_item(Itens.FOLHA_DE_ARVORE)
	add_item(Itens.FRUTA_VERMELHA)
	add_item(Itens.GALHO_FRAGIL)
	add_item(Itens.GALHO_GRANDE)
	add_item(Itens.GOSMA_SLIME_VERDE)
	add_item(Itens.GOSMA_SLIME_VERMELHO)
	add_item(Itens.GRAVETO)
	add_item(Itens.LASCA_DE_MADEIRA)
	add_item(Itens.LEITE)
	add_item(Itens.MACHADO_MADEIRA)
	add_item(Itens.MUDA_DE_ARVORE)
	add_item(Itens.PROTETOR_DE_MAO)
	add_item(Itens.TABUA)
	
	return list

func add_item(obj):
	var item_list : Dictionary = {
		'sprite' : "res://resources/itens/" + obj.sprite,
		'nome' : obj.nome
	}
	
	list.append(item_list)
