extends Node

class_name Status

@warning_ignore("unused_signal")
signal statusChange(status)
@warning_ignore("unused_signal")
signal statusLoss(status)
@warning_ignore("unused_signal")
signal satusGain(status)
@warning_ignore("unused_signal")
signal statusIsZero(status)
@warning_ignore("unused_signal")
signal statusIsFull(status)
@warning_ignore("unused_signal")
signal statistic(statistic)

var general_status : Dictionary = {
	'state' : [],
	'max' : [],
	'def' : [],
	'active' : [],
	'on_consum' : [],
	'natural_regen' : [],
	'mask_regen':[]
}

var die_when_zero : StatusInterface.STATUS

var userType

static func create_status(user_type):
	var sts = Status.new()
	sts.userType = user_type
	if user_type.keys().has("vital"):
		sts.die_when_zero = user_type.vital
	else:
		sts.die_when_zero = StatusInterface.STATUS.VIDA
	if user_type.has("born_status_max"):
		sts.set_status_max(user_type.born_status_max.duplicate(true))
		if user_type.has("born_status"):
			sts.set_status(user_type.born_status.duplicate(true))
		else:
			sts.set_status(user_type.born_status_max.duplicate(true))
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
	general_status.max = stts

func set_status(stts):
	general_status.state = stts

func set_status_on_max(idx):
	general_status.state[idx] = general_status.max[idx]

func set_status_def(stts):
	general_status.def = stts

func set_effect(eff):
	general_status.active = eff

func set_effect_consum(consum):
	general_status.on_consum = consum

func set_natural_regen(reg):
	general_status.natural_regen = reg
	general_status.mask_regen.resize(reg.size())
	general_status.mask_regen.fill(0)

func set_regen_flag_active(status):
	general_status.mask_regen[status] = 1

func set_regen_flag_deactive(status):
	general_status.mask_regen[status] = 0

func set_status_from_status_data(data_info):
	self.general_status = data_info.general_status.duplicate(true)
	self.userType = data_info.user_type.duplicate(true)

#func get_life_state():
	#return float(general_status.state[0])/float(general_status.max[0])

#func get_effect():
	#var ef : Array
	#for f in general_status.active.size():
		#ef.append(general_status.active[f])
	#return ef

#func get_defense():
	#return general_status.def

#func get_consum_status():
	#return general_status.on_consum

#func get_consum_status_at(idx):
	#return general_status.on_consum[idx]

#func get_status_data():
	#var data_info : Dictionary = {
		#"general_status" = general_status.duplicate(true)
	#}
	#return data_info

#func has_status_minimal_value(stts:STATUS,value):
	#return general_status.state[stts] >= value

#func is_all_regen_deactive():
	#for mi in general_status.mask_regen:
		#if mi == 1:
			#return false
	#return true

#func activeRegen():
	#general_status.mask_regen.resize(general_status.natural_regen.size())
	#for i in general_status.mask_regen.size():
		#general_status.mask_regen[i] = general_status.natural_regen[i]*general_status.mask_regen[i]
	#StatusInterface.applyEffect({'metric':-1},general_status.mask_regen,self)

#func lifeState():
	#return general_status.state[0]
#
#func fillLife():
	#general_status.state[STATUS.VIDA] = general_status.max[STATUS.VIDA]

#func applyOnStatus(statistic_info,sts,value):
	#if statistic_info.has('metric'):
		#if statistic_info.metric == Estatisticas.COMBATE.ENERGIA_GASTA:
			#statistic_info['cause'] = statistic_info['cause'].get_slice(" - ",0)
			#statistic_info['cause'] += " - " + STATUS.find_key(sts)
		#statistic_info['value'] = value
	#emit_signal_if_connected("statistic",statistic_info)
	#if general_status.state[sts] + value > general_status.max[sts]:
		#general_status.state[sts] = general_status.max[sts]
	#else:
		#general_status.state[sts] += value
	##if sts == die_when_zero:
	#emit_signal_if_connected("statusChange",sts)
	#if value < 0:
		#emit_signal_if_connected("statusLoss",sts)
		#if general_status.state[sts] <= 0:
			#general_status.state[sts] = 0
			##emit_signal_if_connected("statistic",Estatisticas.createCombateMetric(Estatisticas.COMBATE.MORTES,{'cause':statistic_info['agent'],'value':statistic_info['value'],'agent':statistic_info['agent']}))
			#emit_signal_if_connected("statistic",MetricasDeEstatisticas.createMetricMorte(statistic_info['agent'],statistic_info['value'],statistic_info['agent']))
			#emit_signal_if_connected("statusIsZero",sts)
	#elif value > 0:
		#emit_signal_if_connected("statusGain",sts)
		#if general_status.state[sts] == general_status.max[sts]:
			#emit_signal_if_connected("statusIsFull",sts)

#func applyEffect(statistic_info,effect_data):
	#for sts in general_status.state.size():
		#if effect_data[sts] != 0:
			#StatusInterface.applyOnStatus(statistic_info,sts,effect_data[sts],self)

#@warning_ignore("unused_parameter")
#func consumStatus(statistics):
	#var stsConsumable_from_equip = inventory.get_item_consumable_status()
	#
	#for idx in stsConsumable_from_equip.size():
		#stsConsumable_from_equip[idx] += general_status.on_consum[idx]
	#if stsConsumable_from_equip.size() > 0:
		#for sts in general_status.state.size():
			#if stsConsumable_from_equip[sts] != 0:
				#StatusInterface.applyOnStatus(MetricasDeEstatisticas.createMetricConsumoDeEnergia(null,false),sts,stsConsumable_from_equip[sts],self)
				##applyOnStatus(Estatisticas.createCombateMetric(Estatisticas.COMBATE.ENERGIA_GASTA,{'cause':"Consumo de Energia por itens",'value':null,'agent':null}),sts,stsConsumable_from_equip[sts])

func emit_signal_if_connected(signal_name:String,args):
	if get_signal_connection_list(signal_name).size() > 0:
		emit_signal(signal_name,args)
