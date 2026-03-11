extends Node

class_name SMPScript

var in_process_state : bool = false
var process_rate_max : int = 180
var process_rate : int = process_rate_max
var process_count_max : int = 10
var process_count = process_count_max

func _physics_process(delta: float) -> void:
	var nodes_in_group = get_tree().get_nodes_in_group(GameConfig.GROUP_GROWTH)
	in_process_state = nodes_in_group.size() > 0
	if in_process_state :
		if process_rate < 1 :
			process_rate = process_rate_max
			for n in nodes_in_group.size():
				if process_count > 0:
					var node = nodes_in_group.pick_random()
					var node_growth = Placeable.create_placeable(RGrowth.findRelation(node.type))
					node_growth.position = node.position
					node.get_parent().placeOnWorld(node_growth)
					node.remove_from_group(GameConfig.GROUP_GROWTH)
					node.queue_free()
					process_count = process_count - 1
			process_count = process_count_max
		process_rate = process_rate - 1
