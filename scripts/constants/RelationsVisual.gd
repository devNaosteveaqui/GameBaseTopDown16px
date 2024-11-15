extends Node

class_name RVisual

const RELATIONS = [
	{
		'entity_type' : Entities.HUMAN,
		'flags' : {
			'appearance':"humanoide",
			'skin_covering':"pouco pelo",
			'hair':"pouco cabelo e curto",
			'skeleton':"interno",
			'height':1.8,
			'stiffiness':0.8,
			'skin':0.5,
			'legs':2,
			'arms':2,
			'heads':1,
			'fingers':20,
			'eyes':2,
			'noses':1,
			'mounth':1,
			'faces':1,
			'ears':2,
			'muscle':true
		},
		'default_pref' : {
			'appearance':["humanoide"],
			'skin_covering':["pouco pelo"],
			'hair':["pouco cabelo e curto"],
			'skeleton':["interno"],
			'height':[1.8],
			'stiffiness':[0.8],
			'skin':[0.5],
			'legs':[2],
			'arms':[2],
			'heads':[1],
			'fingers':[20],
			'eyes':[2],
			'noses':[1],
			'mounth':[1],
			'faces':[1],
			'ears':[2],
			'muscle':[true]
		}
	},
	{
		'entity_type' : Entities.GREENSLIME,
		'flags' : {
			'appearance':"amorfo",
			'color':"green",
			'skin_viscosity':0.5,
			'height':0.9,
			'stiffiness':0.75,
			'skin':0.2
		},
		'default_pref' : {
			'appearance':["amorfo"],
			'color':["green"],
			'skin_viscosity':[0.5],
			'height':[0.9],
			'stiffiness':[0.75],
			'skin':[0.2]
		}
	}
]
static func findRelation(type):
	for r in RELATIONS:
		if r.entity_type == type:
			return [r.flags,r.default_pref]
	return []
