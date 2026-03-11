extends Node

class_name Placeables

enum PLACEABLES_NAME {TRONCO,PEDRA,ARVORE,ROCHA,ARBUSTO,BLOCK_GREENSLIME,MUDA_DE_ARVORE}

const OBJECT_PLACEABLE = preload("res://scenes/placeable/Placeable.tscn")

const TRONCO = {
	'nome' : "tronco",
	'shape' : preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + "Tronco.tres"),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "tronco.tres"),
	'born_status_def' : [0,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 0,
	'inventory_slots': 0
}
const PEDRA = {
	'nome' : "pedra",
	'shape' : preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + "Pedra.tres"),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "pedra.tres"),
	'born_status_def' : [0,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 0,
	'inventory_slots': 0
}
const ARVORE = {
	'nome' : "arvore",
	'shape' : preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + "/tree.tres"),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "/tree.tres"),
	'born_status_def' : [2,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 1,
	'inventory_slots': 0
}
const ROCHA = {
	'nome' : "rocha",
	'shape' : preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + "/stone.tres"),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "/stone.tres"),
	'born_status_def' : [2,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 1,
	'inventory_slots': 0
}
const ARBUSTO = {
	'nome' : "arbusto",
	'shape' : null, #preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + ""),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "/bush.tres"),
	'born_status_def' : [0,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 1,
	'inventory_slots': 0
}
const BLOCK_GREENSLIME = {
	'nome' : "Bloco de Slime Verde",
	'shape' : preload(GameConfig.PATH_RESOURCE_SHAPE_PLACEABLE + "/green_slime_block.tres"),
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "/green_slime_block.tres"),
	'born_status_def' : [0,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 0,
	'inventory_slots': 0
}

const MUDA_DE_ARVORE = {
	'nome' : "Muda de Arvore",
	'shape' : null,
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_PLACEABLE + "/muda_de_arvore.tres"),
	'born_status_def' : [0,0,0,0],
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'stage_max' : 0,
	'inventory_slots': 0
}
const PLACEABLES = {
	PLACEABLES_NAME.TRONCO : Placeables.TRONCO,
	PLACEABLES_NAME.PEDRA : Placeables.PEDRA,
	PLACEABLES_NAME.ARVORE : Placeables.ARVORE,
	PLACEABLES_NAME.ARBUSTO : Placeables.ARBUSTO,
	PLACEABLES_NAME.ROCHA : Placeables.ROCHA,
	PLACEABLES_NAME.BLOCK_GREENSLIME : Placeables.BLOCK_GREENSLIME,
	PLACEABLES_NAME.MUDA_DE_ARVORE : Placeables.MUDA_DE_ARVORE
}

static func get_placeable_type_by_names(placeable_name:PLACEABLES_NAME):
	return PLACEABLES[placeable_name]
