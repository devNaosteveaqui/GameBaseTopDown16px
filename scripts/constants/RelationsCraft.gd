extends Node

class_name RCraft

const RELATIONS = [
	{
		'result' : {'x1':Itens.ESPADA_MADEIRA},
		'materials' : [
			{'i0x1':Itens.CABO_MADEIRA},
			{'i1x1':Itens.PROTETOR_DE_MAO}
		]
	},
	{
		'result' : {'x2':Itens.PROTETOR_DE_MAO},
		'materials' : [
			{'i0x1':Itens.GRAVETO}
		]
	},
	{
		'result' : {'x2':Itens.CABO_MADEIRA},
		'materials' : [
			{'i0x1':Itens.TABUA}
		]
	},
	{
		'result' : {'x4':Itens.GRAVETO},
		'materials' : [
			{'i0x1':Itens.TABUA}
		]
	},
	{
		'result' : {'x4':Itens.TABUA},
		'materials' : [
			{'i0x1':Itens.TRONCO}
		]
	},
	{
		'result' : {'x2':Itens.CABECA_MACHADO_MADEIRA},
		'materials' : [
			{'i0x1':Itens.TABUA}
		]
	},
	{
		'result' : {'x1':Itens.MACHADO_MADEIRA},
		'materials' : [
			{'i0x1':Itens.CABECA_MACHADO_MADEIRA},
			{'i0x1':Itens.CABO_MADEIRA}
		]
	},
	{
		'result' : {'x1':Itens.BLOCK_GREENSLIME},
		'materials' : [
			{'i0x4':Itens.GOSMA_SLIME_VERDE}
		]
	},
	{
		'result' : {'x1':Itens.BALDE_MADEIRA},
		'materials' : [
			{'i0x4':Itens.TABUA}
		]
	}
]

static func get_recipe_text(index):
	var text = []
	var recipe = RELATIONS[index]
	var keyR = recipe.result.keys()[0]
	text.append("Resultado : " +recipe.result[keyR].nome+ " ( " + keyR.rsplit("x",true,1)[1] + " ) ")
	for m in recipe.materials:
		var mkey = m.keys()[0]
		text.append("/" + mkey.rsplit("x",true,1)[1] + " - " + m[mkey].nome)
	return text

static func get_recipe_result(index):
	var recipe = RELATIONS[index]
	return recipe.result

static func get_recipe_materials(index):
	var materials = []
	for m in RELATIONS[index].materials:
		var mkey = m.keys()[0]
		materials.append([mkey.rsplit('x',true,1)[1],m[mkey]])
	return materials
