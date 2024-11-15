extends Node

class_name SystemBattle

static func makePhysicActionOn(trigger,target,habilidade:Habilidade):
	var energy_consum = habilidade.get_consum()
	
	var statistic_uso_habilidade = {
		'metric':Estatisticas.COMBATE.USO_HABILIDADE,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':"Habilidade Fisica",
		'value':null,
		'agent':habilidade.get_nome()
	}
	var statistic_energy_cost = {
		'metric':Estatisticas.COMBATE.ENERGIA_GASTA,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':"Consumo de Energia por habilidade",
		'agent':"self"
	}
	
	trigger.update_statistic(statistic_uso_habilidade)
	#trigger.try_apply_effect(statistic_energy_cost,energy_consum)
	SystemBattle.apply_effect_on(statistic_energy_cost,energy_consum,trigger)
	trigger.status.consumStatus({'agent':"self"})
	var weapon = trigger.inventory.get_principal_item()
	
	var statistic_dano_recebido : Dictionary = {
		'metric':Estatisticas.COMBATE.DANO_RECEBIDO,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':null,
		'agent':null
	}
	var statistic_dano_causado : Dictionary = {
		'metric':Estatisticas.COMBATE.DANO_CAUSADO,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':null,
		'value':null,
		'agent':null
	
	}
	var statistic_eliminacao : Dictionary = {
		'metric':Estatisticas.COMBATE.ELIMINACOES,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':null,
		'value':null,
		'agent':null
	}
	var statistic_text = "Dano fisico "
	var habEffect
	var agent_name = target.type.nome
	var effect_result : Array
	
	if weapon == null:
		statistic_text += "desarmado "
		if habilidade.requireItemOnHand():
			statistic_text += "sem habilidade"
			habEffect = []
			habEffect.resize(habilidade.get_effect().size())
			habEffect.fill(0)
		else:
			statistic_text += "com " + habilidade.get_nome()
			habEffect = habilidade.get_effect()
		
		statistic_dano_causado.cause = statistic_text
		statistic_dano_recebido.cause = statistic_text
		statistic_eliminacao.cause = statistic_text
		
		if target.hasDefense():
			# Bateu em alguém com armadura de mãos limpas
			statistic_dano_recebido.agent = "self"
			#trigger.try_apply_effect(statistic_dano_recebido,[-1,0,0,0])
			SystemBattle.apply_effect_on(statistic_dano_recebido,[-1,0,0,0],trigger)
		else:
			# Bateu em alguém sem armadura de mãos limpas
			var effect = trigger.status.get_effect()
			
			for id in effect.size():
				effect_result.append(effect[id]+habEffect[id])
			
			statistic_dano_causado.value = effect_result[0]
			statistic_dano_causado.agent = agent_name
			trigger.update_statistic(statistic_dano_causado)
			
			statistic_dano_recebido.agent = trigger.type.nome
			#target.try_apply_effect(statistic_dano_recebido,effect_result)
			SystemBattle.apply_effect_on(statistic_dano_recebido,effect_result,target)
	else:
		statistic_text += "armado com " +weapon.type.nome
		if habilidade.requireItemOnHand():
			statistic_text += " sem habilidade"
			habEffect = []
			habEffect.resize(habilidade.get_effect().size())
			habEffect.fill(0)
		else:
			statistic_text += " com " + habilidade.get_nome()
			habEffect = habilidade.get_effect()
		
		statistic_dano_causado.cause = statistic_text
		statistic_dano_recebido.cause = statistic_text
		statistic_eliminacao.cause = statistic_text
		
		var reduction : float = target.get_reduction_effect_by_item_hardness(weapon)
		
		var effect :Array = trigger.status.get_effect()
		for id in effect.size():
			effect[id] = effect[id]*(1-reduction)
		
		for id in effect.size():
			effect_result.append(effect[id]+habEffect[id])
		
		statistic_dano_causado.value = weapon.get_effect_final(effect_result)[0]
		statistic_dano_causado.agent = target.type.nome
		trigger.update_statistic(statistic_dano_causado)
		
		statistic_dano_recebido.agent = trigger.type.nome
		weapon.useOn(statistic_dano_recebido,target,effect_result)
	
	if target == null:
		statistic_eliminacao.value = effect_result[0]
		statistic_eliminacao.agent = agent_name
		trigger.update_statistic(statistic_eliminacao)
		#aplicar respingos de sange ou residuos da batalha no visual de quem sobreviver

static func apply_effect_on(statistics,effect,target):
	var trgt = target.get_status_class()
	#if target is Entity:
		#statistics['metric'] = Estatisticas.COMBATE.DANO_RECEBIDO
		#statistics['metric_class'] = Estatisticas.ESTATISTICAS_CLASS.COMBATE
	trgt.applyEffect(statistics,effect)

static func get_piece_armor_defense_percent(effect_reduction:float,def_value:float,piece):
	return ((effect_reduction*piece) + def_value)/(piece+1)
