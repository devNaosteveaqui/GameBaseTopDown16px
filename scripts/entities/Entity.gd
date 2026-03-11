extends CharacterBody2D

class_name Entity

signal deathCharacter

@export var target_efect : AnimationPlayer
@export var sprite : AnimatedSprite2D
@export var particles : AnimatedSprite2D
@export var raycast : RayCast2D
@export var lifebar : ColorRect
@export var inventory : Inventory
@export var regen_timer : Timer
@export var moviment_timer : Timer # Precisa de upgrades
@export var area_detect : Area2D # Precisa melhorar
@export var range_attack : Area2D # A ser implementado
@export var collision_detect_on_endjump : Area2D
@export var collision_body_shape : CollisionShape2D
@export var shadow : Sprite2D
@export var text_action_execution : Label

var direction_angle : float = 0
var range_action : int = 24
var inMoviment : int = 0
var crouched_cooldown_max : int = 30
var crouched_cooldown : int = 0
var hitted : bool = false
var hitting : bool = false
var regen_ativated : bool = true
var is_jumping_up : bool = false
var is_jumping_down : bool = false
var is_in_jump : bool = false
var is_jumpend_collide_possible : bool = false
var is_crouched : bool = false
var is_particling : bool = false
var is_death_loop_respawn : bool = false
var is_dead : bool = false
var characterSpeed : Vector2 = Vector2(50,50)
var nextPosition : Vector2
var jump_origin : Vector2
var movimentDirection : Vector2
var chunk_limits : Rect2
var bodys_on_detect : Array
var bodys_on_range_attack : Array

var last_interactable

var status_social : SocialStatus # a ser implementado
var status : Status
var type
var estatisticas : Estatisticas
var habilidades : SistemaHabilidades
var indiomas : SistemaIndiomas
var visual_system : SistemaVisual
var onSelf : bool = false
var calling_skill : bool = false

var sequence_click : Array
var action_on_self : bool

var nome : String

static func create_entity(entity_type,isPlayer:bool):
	var e : Entity= Entities.OBJECT_ENTITY.instantiate()
	e.habilidades = SistemaHabilidades.new()
	e.status_social = SocialStatus.new()
	e.indiomas = SistemaIndiomas.new()
	e.estatisticas = Estatisticas.new()
	e.visual_system = SistemaVisual.new()
	var visuals_flags = RVisual.findRelation(entity_type)
	e.visual_system.init_flags(visuals_flags[0],visuals_flags[1])
	e.inventory.create_inventory()
	e.set_entity_type(entity_type)
	if not isPlayer:
		var drops = RDrop.findRelation(entity_type)
		if drops != null:
			drops = drops.drop_p
			for d in drops:
				var item = ItemInterface.create_data_from_type(d[1],e)
				ItemInterface.set_quantity(item,d[0])
				e.inventory.store_item(item,-3)#"spawnStorage"
		var state_machine : SMScript = SMScript.new()
		e.add_child(state_machine)
		state_machine.set_body(e)
	e.learn_basics_from_type(entity_type)
	e.initStatus()
	GameConfig.create_object(e)
	return e

func _ready():
	add_to_group(GameConfig.GROUP_INTERACTABLE)
	raycast.target_position = Vector2(0,range_action)
	moviment_timer.timeout.connect(call_sequence)
	nextPosition = self.position
	jump_origin = self.position
	inventory.item_storaged.connect(update_statistic)
	area_detect.body_entered.connect(add_body_detected)
	area_detect.body_exited.connect(remove_body_detected)
	range_attack.body_entered.connect(add_body_on_range)
	range_attack.body_exited.connect(remove_body_on_range)

func _process(delta):
	has_targeted()
	if is_crouched:
		if crouched_cooldown <= 0:
			lift()
		crouched_cooldown -= 1
	update_velocity()
	update_animation()
	update_animation_particle()
	move_and_slide()
func _on_animation_looped():
	if sprite.animation == "hitted":
		hitted = false
	if sprite.animation == "hitting":
		hitting = false
func _on_particle_animation_looped() -> void:
	if particles.animation == "relation_up":
		is_particling = false
func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body != self:
		is_jumpend_collide_possible = true

func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if is_jumpend_collide_possible:
		is_jumpend_collide_possible = false
		if not is_in_jump:
			set_collision_shape_flags(0,true)
			#active_collision_shape()

func initStatus():
	status = Status.create_status(type)
	status.connect("statusIsZero",status_is_zero)
	status.connect("statusLoss",status_loss)
	status.connect("statusChange",status_change)
	status.connect("statusIsFull",status_is_full)
	status.connect("statistic",update_statistic)
func set_entity_type(entity_type):
	set_animation(entity_type.animation)
	set_shadow(entity_type.shadow)
	type = entity_type
func set_animation(animation):
	sprite.sprite_frames = animation
	#sprite.sprite_frames = load("res://resources/entities/"+animation)
	sprite.play("default")
func set_shadow(shadow_texture):
	shadow.texture = load("res://resources/entities/"+shadow_texture)
func set_moviment_direction(dir:Vector2):
	movimentDirection = dir
func set_in_moviment():
	inMoviment = 1
func set_not_in_moviment():
	inMoviment = 0
func set_onself(flag:bool):
	onSelf = flag
func set_collision_shape_flags(z_idx:int, value:bool):
	z_index = z_idx
	set_collision_layer_value(1,value)
	set_collision_mask_value(1,value)
func set_chunk_limits(limits:Rect2):
	chunk_limits = limits

func set_range_attack_monitoring_collision_state(monitoring_state:bool):
	if range_attack.monitoring != monitoring_state:
		range_attack.monitoring = monitoring_state

func set_position_on_world(x,y):
	self.position = Vector2(x,y)

func get_direction():
	return raycast.target_position/range_action
func get_position_on_eye():
	return position + raycast.target_position
func get_sequence():
	var seq = []
	for i in sequence_click.size():
		if Movimentos.isMovimentExecution(sequence_click[i]):
			seq.append(sequence_click[i])
			return seq
		seq.append(sequence_click[i])
	return seq
func get_target_on_range():
	return raycast.get_collider()
func get_speed():
	return characterSpeed
func get_inventory_node():
	return inventory
func get_status_class():
	return status
func get_status_social_class():
	return status_social
func get_estatisticas_class():
	return estatisticas
func get_chunk_limits():
	return chunk_limits
func get_targets_nearby(): #maybe del
	return bodys_on_detect
	#return area_detect.get_overlapping_bodies()
func get_area_detect():
	return area_detect
func get_habilitys():
	return habilidades.lista
func get_weapon_name():
	return inventory.get_principal_item_name()
func get_effect_aplicable(effect_aplicable:Array):
	if has_weapon_equiped():
		return ItemInterface.get_effect_final(inventory.get_principal_item(),effect_aplicable)[0]
	return effect_aplicable[0]
func get_weapon_type():
	var item = inventory.get_principal_item()
	if item != null:
		return inventory.get_principal_item().type
	else:
		return null
func get_hardeness_armor_pieces():
	return inventory.get_hardeness_amor_pieces()
func get_defense_amor_value(piece):
	return inventory.get_armor_defense_value(piece,0)

func update_statistic(statistic_metric):
	estatisticas.update_statistic(statistic_metric)
func update_velocity():
	self.velocity = (get_speed()*movimentDirection)*inMoviment
func update_animation():
	if hitting:
		sprite.play("hitting")
	elif hitted:
		sprite.play("hitted")
	elif is_in_jump:
		pass
	elif inMoviment == 1:
		sprite.play("walk")
	else:
		sprite.play("default")
func update_animation_particle():
	if is_particling:
		if not particles.is_visible_in_tree():
			particles.show()
		particles.play("relation_up")
	else:
		particles.stop()
		particles.play("default")
		particles.hide()
func update_lifebar():
	lifebar.size.x = 20.0*(StatusInterface.get_life_state(status.general_status))
#
#func update_entity():
	#if regen_ativated:
		#if regen_timer.time_left == 0:
			#regen_timer.start(10)
			#regen_timer.connect("timeout",status.activeRegen)

func update_shadow_position():
	if is_in_jump:
		shadow.offset = (position - nextPosition)*(-1) + Vector2(0,8)
	else:
		shadow.offset = Vector2(0,8)
func update_character_speed():
	pass

func reset_character_speed():
	characterSpeed = Vector2((50 if self.is_in_group(GameConfig.GROUP_ENTITY_PLAYER) else 40),50)
func reset_character_speed_jump():
	characterSpeed = Vector2((50 if self.is_in_group(GameConfig.GROUP_ENTITY_PLAYER) else 40),100)
func reset_regen_timer():
	regen_timer.start(10)

func try_socialize(entity_name : String,pts : int):
	if pts > 0:
		is_particling = true
	if status_social.knowAbout(entity_name):
		status_social.upgradeRelation(entity_name,pts)
	else:
		status_social.addNewRelation(entity_name)
func try_interact(indioma_list,visual):
	var answer : Dictionary = {
		'understanding' : false,
		'pts_comm' : 0,
		'pts_visual' : 0,
		'pts' : 0
	}
	answer.pts_visual = visual_system.rate_visual(visual)
	if indiomas.hasAnyIndioma(indioma_list):
		answer.understanding = true
		answer.pts_comm = 10
	answer.pts = answer.pts_comm*(1 + answer.pts_visual)
	return answer

func try_use_item():
	var target = get_target_on_range()
	if onSelf:
		target = self
	
	if target == null:
		return
	
	var slotIdx = inventory.get_useable_equiped_slot_idx()
	if slotIdx != -1:
		inventory.use_item_usable(slotIdx,target)

func try_use_item_on_target(statistics,target,effect_result):
	inventory.get_principal_item().use_on(statistics,target,effect_result)

func has_entity_nearby() -> bool:
	#var targets = area_detect.get_overlapping_bodies()
	
	for e in bodys_on_detect:
		if e == self:
			continue
		if e is Entity:
			return true
	return false

func has_stepped_out_chunk():
	if chunk_limits.size.x == 0:
		return true
	var on_x : bool = self.position.x < chunk_limits.position.x || self.position.x > chunk_limits.position.x + chunk_limits.size.x
	var on_y : bool = self.position.y < chunk_limits.position.y || self.position.y > chunk_limits.position.y + chunk_limits.size.y
	
	return (on_x || on_y)

func hasDefense():
	return inventory.get_armor_defense().size() > 0

func has_targeted():
	var collider = get_target_on_range()
	if !(collider == last_interactable or collider == null or collider == self):
		if last_interactable != null:
			if last_interactable.has_method("targeted_effect_deactive"):
				last_interactable.targeted_effect_deactive()
		#if collider.is_in_group(GameConfig.GROUP_INTERACTABLE):
		if collider.has_method("targeted_effect_active"):
			last_interactable = collider
			collider.targeted_effect_active()
	elif (collider == null and last_interactable != null):
		last_interactable.targeted_effect_deactive()
		last_interactable = null

func has_status_to_use_hability(hab:Habilidade):
	var hab_consum = hab.get_consum()
	for s in hab_consum.size():
		if !StatusInterface.has_status_minimal_value(status.general_status,s,hab_consum[s]):
			return false
	return true

func has_weapon_equiped():
	return inventory.has_principal_item()

func call_sequence(sequence=get_sequence()):
	var moviment = Movimentos.get_moviment_sequence_result(sequence)
	var skills_possibilitys = RMovimentos.findRelation(moviment)
	var skill = habilidades.get_hability_with_req(self,skills_possibilitys)
	if moviment != Movimentos.MOVIMENT_FAIL:
		for sk in skills_possibilitys.size():
			if Habilidades.hasHabilityRequirementToUse(skills_possibilitys[sk],self):
				update_statistic(MetricasDeEstatisticas.createMetricHabilidadeUse(moviment,true))
				#update_statistic(Estatisticas.createCombateMetric(Estatisticas.COMBATE.USO_HABILIDADE,{'cause':"Movimento",'value':null,'agent':moviment}))
				if not habilidades.hasHabilidade(skills_possibilitys[sk].nome):
					learn_habilidade(skills_possibilitys[sk].nome)
			else:
				text_action_execution.show_text_miss()
		
	apply_skill(skill)
	moviment_timer.stop()
	interuptSequence()

func call_skill(skill:Habilidade,target):
	if skill.type == Habilidades.PHYSIC_SKILL:
		SystemBattle.makePhysicActionOn(self,target,skill)
		text_action_execution.show_text_hitted()
	elif skill.type == Habilidades.MAGIC_SKILL:
		skill.invokeOnWorld(get_parent(),self)


func call_magic(skill_name):
	if habilidades.hasHabilidade(skill_name):
		call_skill(habilidades.get_habilidade(skill_name),null)

func add_body_detected(body):
	bodys_on_detect.append(body)

func add_body_on_range(body):
	bodys_on_range_attack.append(body)

func remove_body_detected(body):
	bodys_on_detect.erase(body)

func remove_body_on_range(body):
	bodys_on_range_attack.erase(body)

func apply_skill(skill):
	if skill == null:
		return
	if skill.target_area:
		set_range_attack_monitoring_collision_state(true)
		for t in bodys_on_range_attack:
			if onSelf:
				call_skill(skill,t)
			elif t != self:
				call_skill(skill,t)
		set_range_attack_monitoring_collision_state(false)
	elif onSelf:
		call_skill(skill,self)
	else:
		var target = get_target_on_range()
		if target is Entity || target is Placeable:
			call_skill(skill,target)

func apply_damage_on_weapon(damage_on_weapon):
	inventory.get_principal_item().try_apply_effect(damage_on_weapon)

func apply_damage_on_armor(damage_on_armor,piece):
	inventory.damageArmor(damage_on_armor,piece)

func knowHabilidade(hab_name,flag_verify_lvl:bool = false,lvl_min:int =1):
	var condition : bool = habilidades.hasHabilidade(hab_name)
	if flag_verify_lvl and condition:
		condition = habilidades.get_habilidade(hab_name).hasLevel(lvl_min)
	return condition

func init_regen(sts):
	if regen_ativated:
		status.set_regen_flag_active(sts)
		if regen_timer.time_left == 0:
			reset_regen_timer()
			regen_timer.timeout.connect(StatusInterface.apply_regen.bind(status))

func stopRegen(sts):
	if regen_timer.time_left > 0:
		status.set_regen_flag_deactive(sts)
		if StatusInterface.is_all_regen_deactive(status.general_status):
			regen_timer.stop()

func learn_basics_from_type(entity_type):
	var hab_list = RNativeHabilitys.findRelation(entity_type)
	if hab_list != null:
		for hab in hab_list:
			learn_habilidade(hab.nome)
		#learn_habilidade(Habilidades.CONTROLE_MAGICO.nome)
		#learn_habilidade(Habilidades.ESFERA_MAGICA.nome)
		learn_indioma(entity_type.native_lang.nome,SistemaIndiomas.LVL_MAX)
		#learn_indioma(Entities.GREENSLIME.native_lang.nome,1)
func learn_indioma(indioma_name,lvl):
	if not indiomas.hasIndioma(indioma_name):
		indiomas.addIndioma(indioma_name,lvl)
func learn_habilidade(hab_name):
	if RLearn.hasRequirementToLearn(self,hab_name):
		habilidades.addHabilidade(hab_name)

#ACTIONS ENTITY - free_action_

func hit():
	hitted = true
	set_not_in_moviment()
	#update_entity()

func lift():
	is_crouched = false
	collision_body_shape.position = Vector2(0,0)
	if collision_body_shape.shape is CapsuleShape2D:
		collision_body_shape.rotate(-PI/2)
		collision_body_shape.shape.radius = 8
	elif collision_body_shape.shape is CircleShape2D:
		collision_body_shape.shape.radius = 8
func squat():
	makeMoviment(Movimentos.MOVIMENTS.SQUAT)
	crouched_cooldown = crouched_cooldown_max
	if not is_crouched:
		is_crouched = true
		collision_body_shape.position = Vector2(0,4)
		if collision_body_shape.shape is CapsuleShape2D:
			collision_body_shape.rotate(PI/2)
			collision_body_shape.shape.radius = 4
		elif collision_body_shape.shape is CircleShape2D:
			collision_body_shape.shape.radius = 4
func jump():
	if not is_in_jump:
		makeMoviment(Movimentos.MOVIMENTS.JUMP)
		nextPosition = self.position
		jump_origin = self.position
		is_jumping_up = true
		is_in_jump = true
		set_collision_shape_flags(1,false)
		#deactive_collision_shape()

func walk_to(target:Vector2):
	if has_stepped_out_chunk() and !target.is_equal_approx(Vector2.ZERO):
		GameConfig.change_obj_chunk(self)
	var is_only_jump : bool = false
	var jump_dir : Vector2
	var jump_heigth : Vector2 = Vector2(48,48) # jump_fall_distance , jump_heigth
	if target.is_equal_approx(Vector2.ZERO) and is_in_jump:
		is_only_jump = true
	
	#Define a direção do pulo
	if is_jumping_up:
		jump_dir.y = -1
	elif is_jumping_down:
		jump_dir.y = 1
	
	#Define a direção que a entity tem que estar olhando
	if not is_only_jump:
		if not target.is_equal_approx(Vector2(0,0)):
			look_to(target)
	
	#direciona a queda do pulo, ou próxima posição do personagem
	if is_only_jump:
		set_moviment_direction(jump_dir)
	elif is_in_jump:
		var dir_to_next : Vector2 = target
		dir_to_next.y = jump_dir.y
		
		if jump_origin.distance_to(nextPosition + target*0.8) < jump_heigth.x:
			nextPosition = nextPosition + target*0.8
			jump_heigth.y = 48 + (-1)*(jump_origin.y - nextPosition.y)
		
		set_moviment_direction(dir_to_next)
	else:
		set_moviment_direction(target)
	
	#Define se a entity está se movendo ou não
	if target.is_equal_approx(Vector2.ZERO) and not is_in_jump:
		set_not_in_moviment()
	else:
		set_in_moviment()
	
	#Define a velocidade para caso esteja pulando ou não
	if is_in_jump:
		reset_character_speed_jump()
	else:
		reset_character_speed()
	#controla s flags do sistema de pulo
	if is_jumping_up and nextPosition.y - self.position.y > jump_heigth.y:
		is_jumping_up = false
		is_jumping_down = true
	elif is_jumping_down and nextPosition.y - self.position.y <= 0:
		is_jumping_down = false
		is_in_jump = false
		if not is_jumpend_collide_possible:
			set_collision_shape_flags(0,true)
			#active_collision_shape()
	
	#update_ ShadowPosition
	update_shadow_position()


#func active_collision_shape():
	##collision_body_shape.show()
	#z_index = 0
	#set_collision_layer_value(1,true)
	#set_collision_mask_value(1,true)
#func deactive_collision_shape():
	##collision_body_shape.hide()
	#z_index = 1
	#set_collision_layer_value(1,false)
	#set_collision_mask_value(1,false)

func targeted_effect_active():
	target_efect.play("Targeted")

func targeted_effect_deactive():
	target_efect.stop()

func look_to(target : Vector2):
	#set_moviment_direction(target)
	raycast.target_position = target*range_action

func collect(item):
	var isStoraged = inventory.store_item(item,Estatisticas.ITENS.COLETADOS)
	if !isStoraged:
		drop(item)

func drop(item):
	item._drop_on_ground(position)
	get_parent().add_child(item)

func dropAll(itens):
	for i in itens.size():
		var item = itens[i]
		if item is Dictionary:
			item = ItemInterface.drop_item(item)
		if item != null:
			drop(item)

func placeBlock():
	GameConfig.place_on_world(inventory.getItemPlaceable())

func interact():
	var interactable = raycast.get_collider()
	if interactable == null:
		return
	if interactable.has_method("try_interact"):
		var answer = interactable.try_interact(self.indiomas.get_indioma_list(),self.visual_system.get_visual())
		if answer.understanding :
			try_socialize(interactable.nome,answer.pts)
			interactable.try_socialize(self.nome,answer.pts)
func openInterface():
	var struct = raycast.get_collider()
	if struct != null:
		pass
func interuptSequence():
	var size_sequence = sequence_click.size() 
	for i in size_sequence:
		if sequence_click.size() == 0:
			return
		if Movimentos.isMovimentExecution(sequence_click[0]):
			sequence_click.pop_front()
			continue
		sequence_click.pop_front()
func makeMoviment(moviment):
	## Logica
	#-> movimento realizado
	#--> Verifica se já foram adicionados movimentos de mais, se verdade então reseta a sequencia e adiciona a pilha,
	# caso contrário só adiciona na pilha
	#--> A cada movimento inicia-se um timer para que seja executado o movimento
	if sequence_click.size() + 1 > 3:
		interuptSequence()
	moviment_timer.start(0.4)
	sequence_click.append(moviment)

func status_is_zero(sts):
	match sts:
		status.die_when_zero:
			is_dead = true
			if self.is_in_group(GameConfig.GROUP_ENTITY_PLAYER):
				death()
			#death()
		StatusInterface.STATUS.ENERGIA_FISICA:
			init_regen(sts)

func status_loss(sts):
	if sts == StatusInterface.STATUS.VIDA:
		hit()
	init_regen(sts)

func status_change(sts):
	if sts == StatusInterface.STATUS.VIDA:
		update_lifebar()

func status_is_full(sts):
	stopRegen(sts)

func death():
	dropAll(inventory.inventory)
	dropAll(inventory.equiped)
	emit_signal("deathCharacter")
	queue_free()
