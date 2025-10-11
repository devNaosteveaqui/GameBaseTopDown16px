extends Node

class_name Entities

const HUMAN = {
	'nome' : "Humano",
	'animation' : "human/animation/human.tres",
	'shadow':"human/shadow.png",
	'vital' : Status.STATUS.VIDA,
	'native_lang' : Indiomas.HUMAN_PTBR,
	'born_status' : [20,5,5,50],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-5,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0],
}
const GREENSLIME = {
	'nome' : "Slime Verde",
	'animation' : "green_slime/animation/green_slime.tres",
	'shadow':"green_slime/shadow.png",
	'vital' : Status.STATUS.VIDA,
	'native_lang' : Indiomas.LUZMORSE,
	'born_status' : [20,5,5,0],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0]
}
const BROWNCOW = {
	'nome' : "Vaca Marron",
	'animation' : "cow/animation/cow.tres",
	'shadow':"cow/shadow.png",
	'vital' : Status.STATUS.VIDA,
	'native_lang' : Indiomas.MUGIDO,
	'born_status' : [20,5,5,0],
	'born_status_max' : [20,5,5,100],
	'born_effect' : [-1,0,0,0],
	'born_effect_consum' : [0,-1,0,0],
	'born_regen' : [1,1,1,0]
}
