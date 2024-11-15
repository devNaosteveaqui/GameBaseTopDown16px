extends Marker2D

class_name AreaProcessManager

var is_master : bool = false
var monitored_nodes_group : String
@export var monitored_area : Rect2

func set_monitored_area(pos:Vector2,size:Vector2):
	monitored_area = Rect2(pos,size)
func get_monitored_area():
	var area : Rect2 = Rect2(Vector2(0,0),get_child(0).rect.size)
	area.position.x = self.position.x + get_child(0).rect.position.x
	area.position.y = self.position.y + get_child(0).rect.position.y
	return area
func desability_node(node):
	node.set_process(false)
	node.set_physics_process(false)
	# Pausa a reprodução de animações
	if node is AnimationPlayer:
		node.stop()  # Pausa as animações
	
	# Pausa a reprodução de áudio
	if node is AudioStreamPlayer:
		node.stop()  # Pausa o áudio
	
	# Pausa a simulação de corpos físicos
	if node is RigidBody2D:# or node is CharacterBody2D:
		node.sleeping = true  # Pausa a simulação física
	
	# Pausa o processamento de entrada
	node.set_process_input(false)
	node.set_process_unhandled_input(false)

func ability_node(node):
	node.set_process(true)
	node.set_physics_process(true)
	# Pausa a reprodução de animações
	if node is AnimationPlayer:
		node.play()  # Pausa as animações
	
	# Pausa a reprodução de áudio
	if node is AudioStreamPlayer:
		node.play()  # Pausa o áudio
	
	# Pausa a simulação de corpos físicos
	if node is RigidBody2D:# or node is CharacterBody2D:
		node.sleeping = false  # Pausa a simulação física
	
	# Pausa o processamento de entrada
	node.set_process_input(true)
	node.set_process_unhandled_input(true)

func screen_on():
	var nodes = get_tree().get_nodes_in_group(monitored_nodes_group)
	for n in nodes:
		if n is not Marker2D or is_master:
			ability_node(n)

func screen_off():
	var nodes = get_tree().get_nodes_in_group(monitored_nodes_group)
	for n in nodes:
		if n is not Marker2D or is_master:
			desability_node(n)
