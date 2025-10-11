extends Area2D

class_name HAreaInvoke

var spawn_object
var spawn_object_pre_config
var spawn_count : int = 0
var spawn_max : int
var time_cooldown : int = 2

func _ready():
	$Timer.start(time_cooldown)
	$Timer.connect("timeout",spawnEntity)

func spawnEntity():
	if spawn_count < spawn_max:
		var e : Entity = Entity.create_entity(spawn_object, false)
		var spawnPoint : Vector2 = Vector2(position.x,position.y)
		
		spawnPoint.x += randi_range(-48,48)
		spawnPoint.y += randi_range(-48,48)
		e.position = spawnPoint
		get_parent().add_child(e)
		spawn_count += 1
	else:
		queue_free()
