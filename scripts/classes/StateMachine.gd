extends Node
#State Machine
#Version 1.0.0

class_name SMScript

enum STATES {IDLE, FOLLOW, COMBAT, WORK, EXPLORE, SOCIAL, FLEE, DEAD}
var state_calls_list : Dictionary
var last_state : STATES
var current_state : STATES
var target
var body : Entity
var distance_to_targeting : int = 80
var minimal_distance_to_combat : int = 22
var action_delay : int
var change_state_delay : int
var rand_dir_delay : int
var can_process_delay : int
var minimal_chance_to_states : Dictionary = {
	STATES.IDLE : 0.1,
	STATES.WORK : 0.5,
	STATES.EXPLORE : 0.3
}
var detect_area_2d : Area2D
var last_dir : Vector2 = Vector2(0,0)
var can_process : bool = false

func _ready() -> void:
	add_to_group(GameConfig.GROUP_STATEMACHINE)
	add_states_calls(STATES.IDLE, _state_idle , _check_idle)
	add_states_calls(STATES.FOLLOW, _state_follow, _check_follow)
	add_states_calls(STATES.COMBAT, _state_combat, _check_combat)
	add_states_calls(STATES.WORK, _state_work, _check_work)
	add_states_calls(STATES.EXPLORE, _state_explore, _check_explore)
	add_states_calls(STATES.SOCIAL, _state_social, _check_social)
	add_states_calls(STATES.FLEE, _state_flee, _check_flee)
	add_states_calls(STATES.DEAD, _state_dead, _check_dead)
	reset_delay()
	reset_change_state_delay()
	reset_rand_delay()
	reset_can_process_delay()

func _physics_process(delta: float) -> void:
	var args = _create_args()
	if can_process:
		_process_state(delta,args)
		_process_change_state_delay()
	decay_can_process_delay()

func _process_change_state_delay():
	if change_state_delay < 1:
		reset_change_state_delay()
	else:
		decay_change_state_delay()

@warning_ignore("unused_parameter")
func _process_state(delta: float, args : Dictionary):
	state_calls_list[get_state()]['exec_func'].call(args)
	var new_state = state_calls_list[get_state()]['transition_func'].call()
	if new_state != get_state():
		set_current_state(new_state)

func add_states_calls(state : STATES, exec_func : Callable, transition_func : Callable): 
	state_calls_list[state] = {'exec_func':exec_func ,'transition_func':transition_func}

func set_current_state(new_state:STATES):
	last_state = current_state
	current_state = new_state

func set_body(new_body:Entity):
	self.body = new_body
	self.detect_area_2d = new_body.get_area_detect()
	#self.detect_area_2d.body_entered.connect(detect_targets)
	#self.detect_area_2d.body_exited.connect(undetect_target)

func set_target(new_target=null):
	self.target = new_target

func get_state():
	return current_state

func get_target_direction():
	return (target.position - body.position).normalized()

func reset_last_dir():
	last_dir = Vector2.ZERO

func reset_delay():
	action_delay = 30

func reset_change_state_delay():
	change_state_delay = 30

func reset_rand_delay():
	rand_dir_delay = 20 + randi()%41

func reset_can_process_delay():
	var wide = 15 #30 então valor vai de 30 ~ 60
	can_process_delay = wide + randi()%(wide+1)

@warning_ignore("unused_parameter")
func has_fear(target_type):
	var fears : Array = RFears.findFearRelation(body.type)
	if fears.is_empty():
		return false
	return fears.has(target.type)

@warning_ignore("unused_parameter")
func has_hate(target_type):
	var hate : Array = RFears.findHateRelation(body.type)
	if hate.is_empty():
		return false
	return hate.has(target.type)

@warning_ignore("unused_parameter")
func _state_idle(args:Dictionary):
	var has_nearby = verify_entity_around()
	if has_nearby :
		set_target(search_nearby_entity())
	reset_last_dir()
	move_character()
	set_animation("default")

@warning_ignore("unused_parameter")
func _state_follow(args:Dictionary):
	if target == null:
		return
	if verify_target_nearby(distance_to_targeting):
		last_dir = get_target_direction()
		move_character()
	else:
		set_target()

@warning_ignore("unused_parameter")
func _state_combat(args:Dictionary):
	reset_last_dir()
	move_character()
	if action_delay < 1:
		reset_delay()
	else:
		decay_delay()
		return
	var habilidades : Dictionary = { 'physic' : {}, 'magic' : {} }
	var habilitys = body.get_habilitys()
	for hability in habilitys:
		if SistemaHabilidades.is_hability_type(habilitys[hability],Habilidades.PHYSIC_SKILL):
			if (!habilitys[hability].passive) and body.has_status_to_use_hability(habilitys[hability]):
				habilidades.physic[hability] = habilitys[hability]
		elif SistemaHabilidades.is_hability_type(habilitys[hability],Habilidades.MAGIC_SKILL):
			if (!habilitys[hability].passive) and body.has_status_to_use_hability(habilitys[hability]):
				habilidades.magic[hability] = habilitys[hability]
	
	if (randi() == 1 or habilidades.magic.size() == 0) and habilidades.physic.size() > 0:
		var key = habilidades.physic.keys()[(randi()%habilidades.physic.size())]
		call_skill(habilidades.physic[key],target)
	else:
		if habilidades.magic.size() > 0:
			var key = habilidades.magic.keys()[(randi()%habilidades.magic.size())]
			call_skill(habilidades.magic[key],target)
	

@warning_ignore("unused_parameter")
func _state_work(args:Dictionary):
	#pega uma tarefa de trabalho (DTasks) de RalationsNPCTasks
	var tasks = RNPCTasks.findRelation(body.type)
	if tasks != null:
		for t in tasks:
			#print(t)
			pass
		#set_animation(args.current_state_animation)
		pass

@warning_ignore("unused_parameter")
func _state_explore(args:Dictionary):
	if rand_dir_delay < 1:
		reset_rand_delay()
		last_dir = Vector2(randi_range(-1,1),randi_range(-1,1))
	else:
		decay_rand_dir_delay()
	move_character()

@warning_ignore("unused_parameter")
func _state_social(args:Dictionary):
	#set_animation(args.current_state_animation)
	pass

@warning_ignore("unused_parameter")
func _state_flee(args:Dictionary):
	if verify_target_nearby(distance_to_targeting):
		last_dir = (body.position - target.position).normalized()
		move_character()
	else:
		set_target()

@warning_ignore("unused_parameter")
func _state_dead(args:Dictionary):
	#set_animation(args.current_state_animation)
	body.death()

func _check_idle() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.IDLE
	if target != null:
		if has_fear(target.type) :
			return STATES.FLEE
		if has_hate(target.type):
			return STATES.FOLLOW
	if randf() < minimal_chance_to_states[STATES.WORK] :
		return STATES.WORK
	if randf() < minimal_chance_to_states[STATES.EXPLORE] :
		return STATES.EXPLORE
	return STATES.IDLE

func _check_follow() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.FOLLOW
	if target == null :
		return STATES.IDLE
	if verify_target_nearby(minimal_distance_to_combat) and has_hate(target.type):
		return STATES.COMBAT
	return STATES.FOLLOW

func _check_combat() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.COMBAT
	if target == null :
		return STATES.IDLE
	if has_fear(target.type) :
		return STATES.FLEE
	if verify_target_nearby(distance_to_targeting) and (!verify_target_nearby(minimal_distance_to_combat)):
		return STATES.FOLLOW
	return STATES.COMBAT

func _check_work() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.WORK
	if randf() < minimal_chance_to_states[STATES.IDLE] :
		return STATES.IDLE
	return STATES.WORK

func _check_explore() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.EXPLORE
	if randf() < minimal_chance_to_states[STATES.IDLE] :
		return STATES.IDLE
	return STATES.EXPLORE

func _check_social() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.SOCIAL
	if randf() < minimal_chance_to_states[STATES.IDLE] :
		return STATES.IDLE
	return STATES.SOCIAL

func _check_flee() -> STATES:
	if body.is_dead:
		return STATES.DEAD
	#if change_state_delay > 0:
		#return STATES.FLEE
	if target == null :
		return STATES.IDLE
	return STATES.FLEE

func _check_dead() -> STATES:
	return STATES.DEAD

func move_character(args:Dictionary=_create_args()):
	args.body.walk_to(Vector2(args.x,args.y))

func call_skill(skill,target):
	body.call_skill(skill,target)

@warning_ignore("unused_parameter")
func set_animation(animation_name:String):
	pass

func decay_delay(amount:int=1):
	action_delay -= amount

func decay_change_state_delay(amount:int=1):
	change_state_delay -= amount

func decay_rand_dir_delay(amount:int=1):
	rand_dir_delay -= amount

func decay_can_process_delay(amount:int=1):
	can_process_delay -= amount

func search_nearby_entity() -> Entity:
	var target_list = body.get_targets_nearby()
	for tgt in target_list:
		if tgt is Entity:
			#var tgt_p : Vector2 = tgt.position
			if tgt == body or tgt.type == body.type:
				continue
			if verify_target_nearby(distance_to_targeting,tgt):
				return tgt
	return null

func search_nearby_placeable() -> Entity:
	var target_list = body.get_targets_nearby()
	for tgt in target_list:
		if tgt is Placeable:
			#var tgt_p : Vector2 = tgt.position
			if verify_target_nearby(distance_to_targeting,tgt):
				return tgt
	return null

func verify_entity_around() -> bool:
	return body.has_entity_nearby()

func verify_target_nearby(distance,tgt=target) -> bool:
	if tgt == null:
		return false
	var dist = tgt.position.distance_to(body.position)
	return dist < distance

#func detect_targets(new_body:Node2D):
	#if target == null:
		#target = new_body
	#else:
		#var target_priority = 0
		#var new_body_priority = 0
		#target_priority = target_priority + (2 if target is Entity else 0)
		#target_priority = target_priority + (1 if target is Placeable else 0)
		#new_body_priority = new_body_priority + (2 if new_body is Entity else 0)
		#new_body_priority = new_body_priority + (1 if new_body is Placeable else 0)
		#if new_body_priority > target_priority:
			#target = new_body

#func undetect_target(old_body:Node2D):
	#if old_body == target:
		#target = null

func _create_args():
	return {
		'body':body,
		'last_state':last_state,
		'x':last_dir.x,
		'y':last_dir.y,
		'moviment':Movimentos.MOVIMENTS.ACTION
	}

static func sort_execute_states_machine():
	var tree = Engine.get_main_loop() as SceneTree
	#if tree.get_nodes_in_group(GameConfig.GROUP_ENTITY_TO_UPDATE).size() < 1:
		#return
	var group_machines : Array = []
	var group_of_nodes : Array = tree.get_nodes_in_group(GameConfig.GROUP_STATEMACHINE)
	if group_of_nodes.size() > 0:
		for i in 10:
			var machine : SMScript = group_of_nodes.pick_random()
			if machine.can_process_delay < 1:
				machine.reset_can_process_delay()
				machine.can_process = !machine.can_process
				if machine.can_process:
					machine.add_to_group(GameConfig.GROUP_ENTITY_TO_UPDATE)
