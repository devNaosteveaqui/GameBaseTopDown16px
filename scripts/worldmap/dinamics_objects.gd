extends Node2D

@export var chunks_manager : Node2D
@export var world_edited : Array

func placeOnWorld(obj):
	if obj != null:
		var r = chunks_manager.get_chunk_groups(obj.position)
		if r != null:
			if obj.has_method("set_chunk_limits"):
				obj.set_chunk_limits(r[1])
			obj.add_to_group(r[0])
		add_child(obj)

func steped_on_new_chunk(e):
	var r = chunks_manager.get_chunk_groups(e.position)
	
	if r != null:
		e.set_chunk_limits(r[1])
		var groups = e.get_groups()
		for g in groups:
			if g.begins_with("mapM_"):
				e.remove_from_group(g)
				e.add_to_group(r[0])
				return
		e.add_to_group(r[0])
