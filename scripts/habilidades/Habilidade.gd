extends Node

class_name Habilidade

var status : Status
var habRef
var type : String
var requisitos_use : Array
var status_condition : Array
var target_area : bool
var passive : bool
var lvl : int = 1

static func create_habilidade(type_info):
	var hab = Habilidade.new()
	hab.status = Status.create_status([],type_info)
	hab.habRef = type_info
	hab.type = type_info.type
	hab.requisitos_use = type_info.requisitos_use
	hab.status_condition = type_info.status_condition
	hab.target_area = type_info.target_area
	hab.passive = type_info.passive
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
	var statistic_uso_habilidade = MetricasDeEstatisticas.createMetricHabilidadeUse(self)
	#var statistic_uso_habilidade = Estatisticas.createCombateMetric(Estatisticas.COMBATE.USO_HABILIDADE,{'cause':"Habilidade Mágica",'value':null,'agent':get_nome()})
	var statistic_energy_cost = MetricasDeEstatisticas.createMetricConsumoDeEnergia("self")
	#var statistic_energy_cost = Estatisticas.createCombateMetric(Estatisticas.COMBATE.ENERGIA_GASTA,{'cause':"Consumo de Energia por habilidade",'value':null,'agent':"self"})
	caster.update_statistic(statistic_uso_habilidade)
	SystemBattle.apply_effect_on(statistic_energy_cost,get_consum(),caster)
	#caster.try_apply_effect(statistic_energy_cost,get_consum())
	var hab
	if target_area:
		if habRef.isAreaEffect:
			hab = create_area_effect(caster)
		else:
			hab = create_area_invoke(caster)
	else:
		hab = create_projetil(caster)
	world.add_child(hab)

func create_area_effect(caster:Entity):
	var hab : Area2D= load("res://scenes/habilidades/HabilidadeAreaEffect.tscn").instantiate()
	hab.set_script(load("res://scripts/habilidades/HabilidadeAreaEffect.gd"))
	hab.spawn_max = 10
	hab.caster = caster
	hab.type = habRef
	hab.hab_effect = status.get_effect()
	hab.time_cooldown = 1.5
	hab.position = caster.get_position_on_eye()
	GameConfig.create_object(hab)
	return hab

func create_area_invoke(caster:Entity):
	var hab : Area2D= load("res://scenes/habilidades/HabilidadeAreaEffect.tscn").instantiate()
	hab.set_script(load("res://scripts/habilidades/HabilidadeAreaInvoke.gd"))
	hab.spawn_max = 10
	#hab.spawn_object =  #Criar Relações de invocacoes
	#hab.spawn_object_pre_config = #Criar relaões de invocações
	hab.position = caster.get_position_on_eye()
	GameConfig.create_object(hab)
	return hab

func create_projetil(caster:Entity):
	var hab : HProjetil = load("res://scenes/habilidades/HabilidadeProjetil.tscn").instantiate()
	hab.position = caster.get_position_on_eye()
	hab.timer_duration = 180
	hab.dir = caster.get_direction()
	hab.hab_effect = status.get_effect()
	hab.type = habRef
	hab.caster = caster
	GameConfig.create_object(hab)
	return hab

static func calculateOnConsumStatus(v_step:float,v_base,stats):
	return v_step*(v_base+stats)

func calculateAreaEffect():
	return calculateOnConsumStatus(16,lvl,status.get_consum_status_at(3))

func calculateTimerDurationEffect():
	return calculateOnConsumStatus(60,lvl,status.get_consum_status_at(3))

func calculateTimerCooldownEffect():
	return calculateOnConsumStatus(1/60,lvl,status.get_consum_status_at(3))

func calculateDistanceFired():
	return 16*(2+randi_range(lvl,lvl+status.get_consum_status()[3]))

func requireItemOnHand():
	for r in requisitos_use:
		if r.objective == Habilidades.EMPUNHAVEL_EQUIPED:
			return true
	return false

func hasLevel(lvl_min:int):
	return lvl >= lvl_min
