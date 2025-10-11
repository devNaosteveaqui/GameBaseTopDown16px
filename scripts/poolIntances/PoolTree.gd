extends Node

class_name PoolTree

@export var scene : PackedScene
@export var initial_size : int = 10

var _pool : Array = []

func _ready() -> void:
	for i in range(initial_size):
		var obj = scene.instantiate()
		obj.visible = false
		add_child(obj)
		_pool.append(obj)

func get_object():
	var obj = _pool.pop_back() if _pool.is_empty() else scene.instantiate()
	obj.set_process(true)
	obj.set_physics_process(true)
	obj.visible = true
	add_child(obj)
	return obj

func recycle_object(obj:Node):
	obj.visible = false
	obj.set_physics_process(false)
	obj.set_process(false)
	_pool.append(obj)
