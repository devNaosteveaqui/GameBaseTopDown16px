extends Node

class_name StatusInterface

enum STATUS {VIDA,ENERGIA_FISICA,ENERGIA_MAGICA,ENERGIA_ESPIRITUAL,ENERGIA_SOCIAL}

static func get_life_state(general_status:Dictionary):
	return float(general_status.state[0])/float(general_status.max[0])

static func get_effect(general_status:Dictionary):
	var ef : Array
	for f in general_status.active.size():
		ef.append(general_status.active[f])
	return ef

static func get_defense(general_status:Dictionary):
	return general_status.def

static func get_consum_status(general_status:Dictionary):
	return general_status.on_consum

static func get_consum_status_at(general_status:Dictionary,idx):
	return general_status.on_consum[idx]

static func get_general_status(status):
	return status.general_status

static func get_status_data(general_status:Dictionary,user_type):
	var data_info : Dictionary = {
		"general_status" : general_status.duplicate(true),
		"user_type":user_type.duplicate(true)
	}
	return data_info

static func create_data_from_type(user_type):
	var general_status = {
		'state' : user_type.born_status.duplicate(true) if user_type.has("born_status") else [],
		'max' : user_type.born_status_max.duplicate(true) if user_type.has("born_status_max") else [],
		'def' : user_type.born_status_def.duplicate(true) if user_type.has("born_status_def") else [],
		'active' : user_type.born_effect.duplicate(true) if user_type.has("born_effect") else [],
		'on_consum' : user_type.born_effect_consum.duplicate(true) if user_type.has("born_effect_consum") else [],
		'natural_regen' : user_type.born_regen.duplicate(true) if user_type.has("born_regen") else [],
		'mask_regen': []
	}
	if user_type.has("born_regen"):
		general_status["mask_regen"].resize(user_type.born_regen.size())
		general_status["mask_regen"].fill(0)
	if user_type.has("born_status_max") and not(user_type.has("born_status")):
		general_status["state"] = user_type.born_status_max.duplicate(true)
	
	var data_info : Dictionary = {
		"general_status" : general_status.duplicate(true),
		"user_type":user_type.duplicate(true)
	}
	return data_info

static func has_status_minimal_value(general_status:Dictionary,stts:STATUS,value):
	return general_status.state[stts] >= value

static func is_all_regen_deactive(general_status:Dictionary):
	for mi in general_status.mask_regen:
		if mi == 1:
			return false
	return true

static func applyOnStatus(statistic_info,sts,value,status_node:Status):
	if statistic_info.has('metric'):
		if statistic_info.metric == Estatisticas.COMBATE.ENERGIA_GASTA:
			statistic_info['cause'] = statistic_info['cause'].get_slice(" - ",0)
			statistic_info['cause'] += " - " + STATUS.find_key(sts)
		statistic_info['value'] = value
	status_node.emit_signal_if_connected("statistic",statistic_info)
	if status_node.general_status.state[sts] + value > status_node.general_status.max[sts]:
		status_node.general_status.state[sts] = status_node.general_status.max[sts]
	else:
		status_node.general_status.state[sts] += value
	#if sts == die_when_zero:
	status_node.emit_signal_if_connected("statusChange",sts)
	if value < 0:
		status_node.emit_signal_if_connected("statusLoss",sts)
		if status_node.general_status.state[sts] <= 0:
			status_node.general_status.state[sts] = 0
			#emit_signal_if_connected("statistic",Estatisticas.createCombateMetric(Estatisticas.COMBATE.MORTES,{'cause':statistic_info['agent'],'value':statistic_info['value'],'agent':statistic_info['agent']}))
			status_node.emit_signal_if_connected("statistic",MetricasDeEstatisticas.createMetricMorte(statistic_info['agent'],statistic_info['value'],statistic_info['agent']))
			status_node.emit_signal_if_connected("statusIsZero",sts)
	elif value > 0:
		status_node.emit_signal_if_connected("statusGain",sts)
		if status_node.general_status.state[sts] == status_node.general_status.max[sts]:
			status_node.emit_signal_if_connected("statusIsFull",sts)

static func applyEffect(statistic_info,effect_data,status_node:Status):
	for sts in status_node.general_status.state.size():
		if effect_data[sts] != 0:
			StatusInterface.applyOnStatus(statistic_info,sts,effect_data[sts],status_node)

static func apply_regen(status_node:Status):
	status_node.general_status.mask_regen.resize(status_node.general_status.natural_regen.size())
	for i in status_node.general_status.mask_regen.size():
		status_node.general_status.mask_regen[i] = status_node.general_status.natural_regen[i]*status_node.general_status.mask_regen[i]
	StatusInterface.applyEffect({'metric':-1},status_node.general_status.mask_regen,status_node)

static func apply_consum_status(statistics,status_node:Status,inventory:Inventory):
	var stsConsumable_from_equip = inventory.get_item_consumable_status()
	
	for idx in stsConsumable_from_equip.size():
		stsConsumable_from_equip[idx] += status_node.general_status.on_consum[idx]
	if stsConsumable_from_equip.size() > 0:
		for sts in status_node.general_status.state.size():
			if stsConsumable_from_equip[sts] != 0:
				StatusInterface.applyOnStatus(MetricasDeEstatisticas.createMetricConsumoDeEnergia(null,false),sts,stsConsumable_from_equip[sts],status_node)
				#applyOnStatus(Estatisticas.createCombateMetric(Estatisticas.COMBATE.ENERGIA_GASTA,{'cause':"Consumo de Energia por itens",'value':null,'agent':null}),sts,stsConsumable_from_equip[sts])

static func lifeState(general_status:Dictionary):
	return general_status.state[0]

static func fill_life(status_node:Status):
	status_node.set_status_on_max(STATUS.VIDA)
