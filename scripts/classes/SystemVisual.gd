extends Node
class_name SistemaVisual

const SELF = 0
const PREF = 1
const AVER = 2
const TEMP = 3

var visual_props : Dictionary = {
	'appearance' : ["",[],[],""], #humanoide, amorfo
	'skin_covering': ["",[],[],""], #pêlo, escamas
	'hair':["",[],[],""],#longo, curto
	'color' :["",[],[],""],
	'leaves':["",[],[],""],#pouco, muito, médio
	'skeleton':["",[],[],""], #possui, exoesqueleto
	'skin_viscosity' : [0,[],[],0], # valor entre 0 nenhuma e 1 pura água
	'height' : [0,[],[],0],
	'stiffiness' : [0,[],[],0], #O quão rigido é 0 é um fantasma, 1 é a coisa mais sólida que já viu
	'skin':[0,[],[],0],# 0(não possui pele) - 1(A pele é tão grossa que é o couro mais dificil de processar)
	'legs':[0,[],[],0], #quantidade
	'arms':[0,[],[],0],
	'heads':[0,[],[],0],
	'tails':[0,[],[],0],
	'horns':[0,[],[],0],
	'fingers':[0,[],[],0],
	'eyes':[0,[],[],0],
	'noses':[0,[],[],0],
	'mounth':[0,[],[],0],
	'faces':[0,[],[],0],
	'ears':[0,[],[],0],
	'gills':[0,[],[],0],#quantas branqueas terá
	'fins':[0,[],[],0], #quantas nadadeiras terá
	'wings':[0,[],[],0], #quantos pares de asas terá
	'fangs':[0,[],[],0],
	'claws':[0,[],[],0],
	'flowers':[0,[],[],0],
	'muscle':[false,[],[],false]
}
#var visual_flags : Dictionary = {
	#'appearance' : "", #humanoide, amorfo
	#'skin_covering': "", #pêlo, escamas
	#'hair':"",#longo, curto
	#'color' :"",
	#'leaves':"",#pouco, muito, médio
	#'skeleton':"", #possui, exoesqueleto
	#'skin_viscosity' : 0, # valor entre 0 nenhuma e 1 pura água
	#'height' : 0,
	#'stiffiness' : 0, #O quão rigido é 0 é um fantasma, 1 é a coisa mais sólida que já viu
	#'skin':0,# 0(não possui pele) - 1(A pele é tão grossa que é o couro mais dificil de processar)
	#'legs':0, #quantidade
	#'arms':0,
	#'heads':0,
	#'tails':0,
	#'horns':0,
	#'fingers':0,
	#'eyes':0,
	#'noses':0,
	#'mounth':0,
	#'faces':0,
	#'ears':0,
	#'gills':0,#quantas branqueas terá
	#'fins':0, #quantas nadadeiras terá
	#'wings':0, #quantos pares de asas terá
	#'fangs':0,
	#'claws':0,
	#'flowers':0,
	#'muscle':false
#}
#var visual_flags_pref : Dictionary = {
	#'appearance' :[],
	#'skin_covering':[],
	#'hair':[],
	#'color' : [],
	#'leaves':[],
	#'skeleton':[],
	#'skin_viscosity' : [],
	#'height' : [],
	#'stiffiness' : [],
	#'skin':[],
	#'legs':[],
	#'arms':[],
	#'heads':[],
	#'tails':[],
	#'horns':[],
	#'fingers':[],
	#'eyes':[],
	#'noses':[],
	#'mounth':[],
	#'faces':[],
	#'ears':[],
	#'gills':[],
	#'fins':[],
	#'wings':[],
	#'fangs':[],
	#'claws':[],
	#'flowers':[],
	#'muscle':[]
#}
#var visual_flags_aversion : Dictionary = {
	#'appearance' :[],
	#'skin_covering':[],
	#'hair':[],
	#'color' : [],
	#'leaves':[],
	#'skeleton':[],
	#'skin_viscosity' : [],
	#'height' : [],
	#'stiffiness' : [],
	#'skin':[],
	#'legs':[],
	#'arms':[],
	#'heads':[],
	#'tails':[],
	#'horns':[],
	#'fingers':[],
	#'eyes':[],
	#'noses':[],
	#'mounth':[],
	#'faces':[],
	#'ears':[],
	#'gills':[],
	#'fins':[],
	#'wings':[],
	#'fangs':[],
	#'claws':[],
	#'flowers':[],
	#'muscle':[]
#}

func init_flags(flags,flags_pref={}):
	for k in flags.keys():
		set_visual_flag(k,flags[k])
	for k in flags_pref.keys():
		set_visual_flag_pref(k,flags_pref[k])

func set_visual_flag(flag,value):
	#visual_flags[flag]=value
	visual_props[flag][SistemaVisual.SELF] = value

func set_visual_flag_pref(flag,value):
	#visual_flags_pref[flag] = value
	visual_props[flag][SistemaVisual.PREF] = value

func set_visual_flag_temp(flag,value):
	visual_props[flag][SistemaVisual.TEMP] = value

func addVisualFlagPref(flag:String,values:Array):
	for v in values:
		if not visual_props[flag][SistemaVisual.PREF].has(v):
			visual_props[flag][SistemaVisual.PREF].append(v)

func get_visual():
	var flags : Dictionary = {}
	for k in visual_props.keys():
		if proVisualTempNotDefault(k):
			flags[k] = visual_props[k][SistemaVisual.SELF]
		else:
			flags[k] = visual_props[k][SistemaVisual.TEMP]
	return flags

func proVisualTempNotDefault(prop):
	match typeof(visual_props[prop][SistemaVisual.TEMP]):
		TYPE_STRING:
			return visual_props[prop][SistemaVisual.TEMP] != ""
		TYPE_INT:
			return visual_props[prop][SistemaVisual.TEMP] != 0
		_:
			return true

func rate_visual(visual:Dictionary)->float:
	var points : float = 0.0
	for k in visual_props.keys():
		if visual_props[k][SistemaVisual.PREF].has(visual[k]) and (not visual_props[k][SistemaVisual.PREF].is_empty()):
			points = points + 1.0
		elif visual_props[k][SistemaVisual.AVER].has(visual[k]):
			points = points - 1.0
	return points/visual_props.keys().size()
