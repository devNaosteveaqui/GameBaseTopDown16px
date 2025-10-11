extends Node

class_name SystemBattle

static func makePhysicActionOn(trigger,target,habilidade:Habilidade):
	
	if trigger == null or target == null:
		return
	
	var energy_consum = habilidade.get_consum()
	
	var statistic_uso_habilidade = MetricasDeEstatisticas.createMetricHabilidadeUse(habilidade)
	var statistic_energy_cost = MetricasDeEstatisticas.createMetricConsumoDeEnergia("self")
	#var statistic_uso_habilidade = Estatisticas.createCombateMetric(Estatisticas.COMBATE.USO_HABILIDADE,{'cause':"Habilidade Fisica",'value':null,'agent':habilidade.get_nome()})
	#var statistic_energy_cost = Estatisticas.createCombateMetric(Estatisticas.COMBATE.ENERGIA_GASTA,{'cause':"Consumo de Energia por habilidade",'value':null,'agent':"self"})
	
	trigger.update_statistic(statistic_uso_habilidade)
	#trigger.try_apply_effect(statistic_energy_cost,energy_consum)
	SystemBattle.apply_effect_on(statistic_energy_cost,energy_consum,trigger)
	trigger.status.consumStatus({'agent':"self"})
	var weapon = trigger.inventory.get_principal_item()
	
	var statistic_dano_recebido : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_RECEBIDO)
	var statistic_dano_causado : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_CAUSADO)
	var statistic_eliminacao : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.ELIMINACOES)
	
	var cause = "Dano fisico "
	var value
	var agent = target.type.nome
	
	#var statistic_text = "Dano fisico "
	var habEffect
	var agent_name = target.type.nome
	var effect_result : Array
	
	if weapon == null:
		#statistic_text += "desarmado "
		cause += "desarmado "
		if habilidade.requireItemOnHand():
			#statistic_text += "sem habilidade"
			cause += "sem habilidade"
			habEffect = []
			habEffect.resize(habilidade.get_effect().size())
			habEffect.fill(0)
		else:
			#statistic_text += "com " + habilidade.get_nome()
			cause += "com " + habilidade.get_nome()
			habEffect = habilidade.get_effect()
		
		#statistic_dano_causado.cause = statistic_text
		#statistic_dano_recebido.cause = statistic_text
		#statistic_eliminacao.cause = statistic_text
		
		if target.hasDefense():
			# Bateu em alguém com armadura de mãos limpas
			#statistic_dano_recebido.agent = "self"
			agent = "self"
			#trigger.try_apply_effect(statistic_dano_recebido,[-1,0,0,0])
			#SystemBattle.apply_effect_on(statistic_dano_recebido,[-1,0,0,0],trigger)
			SystemBattle.apply_effect_on(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),[-1,0,0,0],trigger)
		else:
			# Bateu em alguém sem armadura de mãos limpas
			var effect = trigger.status.get_effect()
			
			for id in effect.size():
				effect_result.append(effect[id]+habEffect[id])
			
			#statistic_dano_causado.value = effect_result[0]
			value = effect_result[0]
			#statistic_dano_causado.agent = agent_name
			agent = agent_name
			trigger.update_statistic(MetricasDeEstatisticas.createMetricDanoCausado(cause,agent,value,false))
			#trigger.update_statistic(statistic_dano_causado)
			
			#statistic_dano_recebido.agent = trigger.type.nome
			agent = trigger.type.nome
			#SystemBattle.apply_effect_on(statistic_dano_recebido,effect_result,target)
			SystemBattle.apply_effect_on(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),effect_result,target)
	else:
		#statistic_text += "armado com " +weapon.type.nome
		cause += "armado com " +weapon.type.nome
		if habilidade.requireItemOnHand():
			#statistic_text += " sem habilidade"
			cause += " sem habilidade"
			habEffect = []
			habEffect.resize(habilidade.get_effect().size())
			habEffect.fill(0)
		else:
			#statistic_text += " com " + habilidade.get_nome()
			cause += " com " + habilidade.get_nome()
			habEffect = habilidade.get_effect()
		
		#statistic_dano_causado.cause = statistic_text
		#statistic_dano_recebido.cause = statistic_text
		#statistic_eliminacao.cause = statistic_text
		
		var reduction : float = target.get_reduction_effect_by_item_hardness(weapon)
		
		var effect :Array = trigger.status.get_effect()
		for id in effect.size():
			effect[id] = effect[id]*(1-reduction)
		
		for id in effect.size():
			effect_result.append(effect[id]+habEffect[id])
		
		#statistic_dano_causado.value = weapon.get_effect_final(effect_result)[0]
		value = weapon.get_effect_final(effect_result)[0]
		#statistic_dano_causado.agent = target.type.nome
		agent = target.type.nome
		#trigger.update_statistic(statistic_dano_causado)
		trigger.update_statistic(MetricasDeEstatisticas.createMetricDanoCausado(cause,agent,value,false))
		
		#statistic_dano_recebido.agent = trigger.type.nome
		agent = trigger.type.nome
		#weapon.useOn(statistic_dano_recebido,target,effect_result)
		weapon.useOn(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),target,effect_result)

	if target == null:
		value = effect_result[0]
		#statistic_eliminacao.value = effect_result[0]
		agent = agent_name
		#statistic_eliminacao.agent = agent_name
		#trigger.update_statistic(statistic_eliminacao)
		trigger.update_statistic(MetricasDeEstatisticas.createMetricEliminacoes(cause,agent,value,false))
		#aplicar respingos de sange ou residuos da batalha no visual de quem sobreviver

static func apply_effect_on(statistics,effect,target):
	var trgt = target.get_status_class()
	trgt.applyEffect(statistics,effect)

static func get_piece_armor_defense_percent(effect_reduction:float,def_value:float,piece):
	return ((effect_reduction*piece) + def_value)/(piece+1)
