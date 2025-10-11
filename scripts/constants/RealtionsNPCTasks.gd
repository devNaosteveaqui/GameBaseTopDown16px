extends Node

class_name RNPCTasks

enum TASKS {DEFAULT,CRAFT}

const RELATIONS = [
	{
		'entity_type' : Entities.GREENSLIME,
		'tasks' : [TASKS.DEFAULT]
	},
	{
		'entity_type' : Entities.HUMAN,
		'tasks' : [TASKS.CRAFT]
	},
	{
		'entity_type' : Entities.BROWNCOW,
		'tasks' : [TASKS.DEFAULT]
	}
]

static func findRelation(entity_type):
	for rel in RELATIONS:
		if rel.entity_type == entity_type:
			if rel.tasks.size() < 1:
				return null
			return rel.tasks.duplicate(true)
	return null
