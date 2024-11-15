extends Node

class_name Habilidade

var status : Status
var habRef
var type : String
var requisitos_use : Array
var status_condition : Array
var target_area : bool
var lvl : int = 1

static func createHabilidade(type):
	var hab = Habilidade.new()
	hab.status = Status.createStatus([],type)
	hab.habRef = type
	hab.type = type.type
	hab.requisitos_use = type.requisitos_use
	hab.status_condition = type.status_condition
	hab.target_area = type.target_area
	
	return hab

func get_nome():
	return habRef.nome

func get_consum():
	var consum : Array = status.get_consum_status()
	for i in consum.size():
		consum[i] = consum[i]*lvl
	return consum

func get_effect():
	var effect : Array = status.get_effect()
	for i in effect.size():
		effect[i] = effect[i]*lvl
	return effect

func get_status_condition():
	return status_condition

func get_habilidade_nome():
	return habRef.nome

func invokeOnWorld(world,caster:Entity):
	var statistic_uso_habilidade = {
		'metric':Estatisticas.COMBATE.USO_HABILIDADE,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':"Habilidade Mágica",
		'value':null,
		'agent':get_nome()
	}
	var statistic_energy_cost = {
		'metric':Estatisticas.COMBATE.ENERGIA_GASTA,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':"Consumo de Energia por habilidade",
		'agent':"self"
	}
	caster.update_statistic(statistic_uso_habilidade)
	SystemBattle.apply_effect_on(statistic_energy_cost,get_consum(),caster)
	#caster.try_apply_effect(statistic_energy_cost,get_consum())
	var hab
	if target_area:
		if habRef.isAreaEffect:
			hab = createAreaEffect(caster)
		else:
			hab = createAreaInvoke(caster)
	else:
		hab = createProjetil(caster)
	world.add_child(hab)

func createAreaEffect(caster:Entity):
	var hab : Area2D= load("res://scenes/habilidades/HabilidadeAreaEffect.tscn").instantiate()
	hab.set_script(load("res://scripts/habilidades/HabilidadeAreaEffect.gd"))
	hab.spawn_max = 10
	hab.caster = caster
	hab.type = habRef
	hab.hab_effect = status.get_effect()
	hab.time_cooldown = 1.5
	hab.position = caster.get_position_on_eye()
	return hab

func createAreaInvoke(caster:Entity):
	var hab : Area2D= load("res://scenes/habilidades/HabilidadeAreaEffect.tscn").instantiate()
	hab.set_script(load("res://scripts/habilidades/HabilidadeAreaInvoke.gd"))
	hab.spawn_max = 10
	#hab.spawn_object =  #Criar Relações de invocacoes
	#hab.spawn_object_pre_config = #Criar relaões de invocações
	hab.position = caster.get_position_on_eye()
	return hab

func createProjetil(caster:Entity):
	var hab : HProjetil = load("res://scenes/habilidades/HabilidadeProjetil.tscn").instantiate()
	hab.position = caster.get_position_on_eye()
	hab.timer_duration = 180
	hab.dir = caster.get_direction()
	hab.hab_effect = status.getEffect()
	hab.type = habRef
	hab.caster = caster
	return hab

func calculateAreaEffect():
	return 16*(lvl+status.get_consum_status()[3])

func calculateTimerDurationEffect():
	return 60*(lvl+status.get_consum_status()[3])

func calculateTimerCooldownEffect():
	return 60/(lvl+status.get_consum_status()[3])

func calculateDistanceFired():
	return 16*(2+randi_range(lvl,lvl+status.get_consum_status()[3]))

func requireItemOnHand():
	for r in requisitos_use:
		if r.objective == Habilidades.EMPUNHAVEL_EQUIPED:
			return true
	return false

func hasLevel(lvl_min:int):
	return lvl >= lvl_min
