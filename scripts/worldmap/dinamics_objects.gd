extends Node2D

@export var chunks_manager : Node2D
@export var world_edited : Array

func placeOnWorld(obj):
	if obj == null:
		return
	var r = chunks_manager.get_chunk_groups(obj.position)
	if r != null:
		if obj.has_method("set_chunk_limits"):
			obj.set_chunk_limits(r[1])
		obj.add_to_group(r[0])
		
		if obj is Placeable:
			if has_entity_in_chunk(r[0]):
				obj.set_monitoring_collision_state(true)
			if obj.type == Placeables.MUDA_DE_ARVORE:
				obj.add_to_group(GameConfig.GROUP_GROWTH)
	add_child(obj)

func steped_on_new_chunk(e):
	var r = chunks_manager.get_chunk_groups(e.position)
	
	if r == null:
		return
	
	e.set_chunk_limits(r[1])
	var groups = e.get_groups()
	for g in groups:
		if g.begins_with("mapM_"):
			e.remove_from_group(g)
			e.add_to_group(r[0])
			if e is Entity:
				if !has_entity_in_chunk(g):
					set_monitoring_collision_state_on_nodes_in_chunk(false,g)
				set_monitoring_collision_state_on_nodes_in_chunk(true,r[0])
			return
	e.add_to_group(r[0])

func has_entity_in_chunk(group_name:String):
	var nodes = get_tree().get_nodes_in_group(group_name)
	for n in nodes:
		if n is Entity:
			return true
	return false

func set_monitoring_collision_state_on_nodes_in_chunk(state:bool,group_name:String):
	var nodes = get_tree().get_nodes_in_group(group_name)
	for n in nodes:
		if n.has_method("set_monitoring_collision_state"):
			n.set_monitoring_collision_state(state)
