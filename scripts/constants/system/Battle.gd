extends Node

class_name SystemBattle

static func makePhysicActionOn(trigger,target,habilidade:Habilidade):
	
	if trigger == null or target == null:
		return
	
	var energy_consum = habilidade.get_consum()
	
	var statistic_uso_habilidade = MetricasDeEstatisticas.createMetricHabilidadeUse(habilidade)
	var statistic_energy_cost = MetricasDeEstatisticas.createMetricConsumoDeEnergia("self")
	
	trigger.update_statistic(statistic_uso_habilidade)
	SystemBattle.apply_effect_on(statistic_energy_cost,energy_consum,trigger)
	StatusInterface.apply_consum_status({'agent':"self"},trigger.status,trigger.inventory)
	
	var statistic_dano_recebido : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_RECEBIDO)
	var statistic_dano_causado : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_CAUSADO)
	var statistic_eliminacao : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.ELIMINACOES)
	
	var cause = "Dano fisico "
	var value
	var agent = target.type.nome
	
	var habEffect
	var agent_name = target.type.nome
	var effect_result : Array
	if target.has_method("hitted_by_item"):
		target.hitted_by_item(trigger.get_weapon_type())
	if not trigger.has_weapon_equiped():
		cause += "desarmado com " + habilidade.get_nome()
		habEffect = habilidade.get_effect()
		
		if target.hasDefense():
			
			# Bateu em alguém com armadura de mãos limpas
			agent = "self"
			SystemBattle.apply_effect_on(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),[-1,0,0,0],trigger)
		else:
			# Bateu em alguém sem armadura de mãos limpas
			var effect = StatusInterface.get_effect(trigger.status.general_status)
			
			for id in effect.size():
				effect_result.append(effect[id]+habEffect[id])
			
			value = trigger.get_effect_aplicable(effect_result)
			agent = agent_name
			trigger.update_statistic(MetricasDeEstatisticas.createMetricDanoCausado(cause,agent,value,false))
			
			agent = trigger.type.nome
			SystemBattle.apply_effect_on(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),effect_result,target)
	else:
		cause += "armado com " + trigger.get_weapon_name() + " com " + habilidade.get_nome()
		habEffect = habilidade.get_effect(true)
		
		var itens_conflict : Dictionary = SystemBattle.get_reduction_effect_by_item_hardness(trigger,target)
		trigger.apply_damage_on_weapon(itens_conflict["damage_on_weapon"])
		
		var reduction : float = itens_conflict["effect_reduction"]
		var effect :Array = StatusInterface.get_effect(trigger.status.general_status)
		for id in effect.size():
			effect[id] = effect[id]*(1-reduction)
		
		for id in effect.size():
			effect_result.append(effect[id]+habEffect[id])
		
		value = trigger.get_effect_aplicable(effect_result)
		agent = agent_name
		trigger.update_statistic(MetricasDeEstatisticas.createMetricDanoCausado(cause,agent,value,false))
		
		agent = trigger.type.nome
		trigger.try_use_item_on_target(MetricasDeEstatisticas.createMetricDanoRecebido(cause,agent,null,false),target,effect_result)
	if target == null:
		value = effect_result[0]
		agent = agent_name
		trigger.update_statistic(MetricasDeEstatisticas.createMetricEliminacoes(cause,agent,value,false))
		#aplicar respingos de sange ou residuos da batalha no visual de quem sobreviver

static func apply_effect_on(statistics,effect,target):
	var trgt = target.get_status_class()
	StatusInterface.applyEffect(statistics,effect,trgt)

static func get_piece_armor_defense_percent(effect_reduction:float,def_value:float,piece):
	return ((effect_reduction*piece) + def_value)/(piece+1)

static func get_reduction_effect_by_item_hardness(trigger,target):
	if target is Entity:
		return SystemBattle.get_reduction_effect_by_item_hardness_on_entity(trigger,target)
	elif target is Placeable:
		return SystemBattle.get_reduction_effect_by_item_hardness_on_placeable(target.type,trigger.get_weapon_type())

static func get_reduction_effect_by_item_hardness_on_entity(trigger,target):
	var effect_reduction : float = 0
	var itemHardness = RUseable.findRelation(trigger.get_weapon_type()).on_item
	var amorPieces = target.get_hardeness_armor_pieces()
	var damage_on_weapon = [0,0,0,0]
	
	for piece in amorPieces.size():
		var rdif = amorPieces[piece] - itemHardness
		if rdif >= 5:
			damage_on_weapon[0] += (-1 + (-1)*(rdif/2))
			effect_reduction = SystemBattle.get_piece_armor_defense_percent(effect_reduction,1.0*target.get_defense_amor_value(piece),piece)
		elif rdif >= 0:
			damage_on_weapon[0] += (-1)
			target.apply_damage_on_armor([-1,0,0,0],piece)
			effect_reduction = SystemBattle.get_piece_armor_defense_percent(effect_reduction,(1.0/(1+rdif))*target.get_defense_amor_value(piece),piece)
		else:
			target.apply_damage_on_armor([-1 + (rdif/2),0,0,0],piece)
			effect_reduction = SystemBattle.get_piece_armor_defense_percent(effect_reduction,(1/abs(rdif))*target.get_defense_amor_value(piece),piece)
	
	return {"effect_reduction":effect_reduction,"damage_on_weapon":damage_on_weapon}

static func  get_reduction_effect_by_item_hardness_on_placeable(target_type,item_type):
	var effect_reduction : float = 1
	var damage_on_weapon = [0,0,0,0]
	var selfHardness = RUseable.findRelation(target_type).on_item
	var itemHardness = RUseable.findRelation(item_type).on_placeable
	
	var rdif = selfHardness - itemHardness
	
	if rdif > 0:
		damage_on_weapon[0] = -1 + (-1)*(rdif/2)
	else:
		effect_reduction = 0
		damage_on_weapon[0] = -1 
	return {"effect_reduction":effect_reduction,"damage_on_weapon":damage_on_weapon}
