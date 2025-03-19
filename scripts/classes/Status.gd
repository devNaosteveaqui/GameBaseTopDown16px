extends Node

class_name Status

signal lifeChange
signal lifeLoss
signal lifeGain
signal lifeIsZero
signal lifeIsFull
signal statistic(statistic)

enum STATUS {VIDA,ENERGIA_FISICA,ENERGIA_MAGICA,ENERGIA_ESPIRITUAL,ENERGIA_SOCIAL}

var status : Array
var status_max : Array
var status_def : Array
var effect : Array
var effectConsum : Array
var naturalRegen : Array
var die_when_zero : STATUS

var inventory
var userType

static func createStatus(inventoryRef,user_type):
	var sts = Status.new()
	sts.inventory = inventoryRef
	sts.userType = user_type
	if user_type.keys().has("vital"):
		sts.die_when_zero = user_type.vital
	else:
		sts.die_when_zero = STATUS.VIDA
	if user_type.has("born_status"):
		sts.set_status(user_type.born_status.duplicate(true))
	if user_type.has("born_status_max"):
		sts.set_status_max(user_type.born_status_max.duplicate(true))
	if user_type.has("born_effect"):
		sts.set_effect(user_type.born_effect.duplicate(true))
	if user_type.has("born_effect_consum"):
		sts.set_effect_consum(user_type.born_effect_consum.duplicate(true))
	if user_type.has("born_regen"):
		sts.set_natural_regen(user_type.born_regen.duplicate(true))
	if user_type.has("born_status_def"):
		sts.set_status_def(user_type.born_status_def.duplicate(true))
	return sts

func set_status_max(stts):
	status_max = stts

func set_status(stts):
	status = stts

func set_status_def(stts):
	status_def = stts

func set_effect(eff):
	effect = eff

func set_effect_consum(consum):
	effectConsum = consum

func set_natural_regen(reg):
	naturalRegen = reg

func get_life_state():
	return float(status[0])/float(status_max[0])

func get_effect():
	var ef : Array
	for f in effect.size():
		ef.append(effect[f])
	return ef

func get_defense():
	return status_def

func get_consum_status():
	return effectConsum

func activeRegen():
	applyEffect({'metric':-1},naturalRegen)

func lifeState():
	return status[0]

func applyOnStatus(statistic_info,sts,value):
	if statistic_info.has('metric'):
		if statistic_info.metric == Estatisticas.COMBATE.ENERGIA_GASTA:
			statistic_info['cause'] = statistic_info['cause'].get_slice(" - ",0)
			statistic_info['cause'] += " - " + STATUS.find_key(sts)
		statistic_info['value'] = value
	emit_signal("statistic",statistic_info)
	if status[sts] + value > status_max[sts]:
		status[sts] = status_max[sts]
	else:
		status[sts] += value
	if sts == die_when_zero:
		emit_signal("lifeChange")
		if value < 0:
			emit_signal("lifeLoss")
			if status[sts] <= 0:
				status[sts] = 0
				statistic_info['metric'] = Estatisticas.COMBATE.MORTES
				statistic_info['metric_class'] = Estatisticas.ESTATISTICAS_CLASS.COMBATE
				statistic_info['value'] = null
				emit_signal("statistic",statistic_info)
				emit_signal("lifeIsZero")
		elif value > 0:
			emit_signal("lifeGain")
			if status[sts] == status_max[sts]:
				emit_signal("lifeIsFull")

func applyEffect(statistic_info,effect_data):
	for sts in status.size():
		if effect_data[sts] != 0:
			applyOnStatus(statistic_info,sts,effect_data[sts])

func consumStatus(statistics):
	var stsConsumable_from_equip = inventory.get_item_consumable_status()
	
	for idx in stsConsumable_from_equip.size():
		stsConsumable_from_equip[idx] += effectConsum[idx]
	if stsConsumable_from_equip.size() > 0:
		statistics['metric'] = Estatisticas.COMBATE.ENERGIA_GASTA
		statistics['metric_class'] = Estatisticas.ESTATISTICAS_CLASS.COMBATE
		statistics['cause'] = "Consumo de Energia por itens"
	if stsConsumable_from_equip.size() > 0:
		for sts in status.size():
			if stsConsumable_from_equip[sts] != 0:
				applyOnStatus(statistics,sts,stsConsumable_from_equip[sts])
