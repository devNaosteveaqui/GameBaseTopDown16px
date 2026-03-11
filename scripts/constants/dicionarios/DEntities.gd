extends Node

class_name Entities

const OBJECT_ENTITY = preload("res://scenes/entities/Entity.tscn")

const HUMAN = {
	'nome' : "Humano",
	'object_type':SystemDictionary.OBJECS_TYPE.ENTITY,
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_ENTITY + "human/animation/human.tres"),
	'shadow':"human/shadow.png",
	'vital' : StatusInterface.STATUS.VIDA,
	'native_lang' : Indiomas.HUMAN_PTBR,
	'born_status' : [20,5,5,50],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-5,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0],
}
const GREENSLIME = {
	'nome' : "Slime Verde",
	'object_type':SystemDictionary.OBJECS_TYPE.ENTITY,
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_ENTITY + "green_slime/animation/green_slime.tres"),
	'shadow':"green_slime/shadow.png",
	'vital' : StatusInterface.STATUS.VIDA,
	'native_lang' : Indiomas.LUZMORSE,
	'born_status' : [20,5,5,0],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0]
}
const BROWNCOW = {
	'nome' : "Vaca Marron",
	'object_type':SystemDictionary.OBJECS_TYPE.ENTITY,
	'animation' : preload(GameConfig.PATH_RESOURCE_ANIMATION_ENTITY + "cow/animation/cow.tres"),
	'shadow':"cow/shadow.png",
	'vital' : StatusInterface.STATUS.VIDA,
	'native_lang' : Indiomas.MUGIDO,
	'born_status' : [20,5,5,0],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0]
}
