extends Node

class_name Status

signal lifeChange
signal lifeLoss
signal lifeGain
signal lifeIsZero
signal lifeIsFull

enum STATUS {VIDA,ENERGIA_FISICA,ENERGIA_MAGICA,ENERGIA_ESPIRITUAL,ENERGIA_SOCIAL}

var status : Array
var status_max : Array
var status_def : Array
var effect : Array
var effectConsum : Array
var naturalRegen : Array

var inventory
var userType

static func createStatus(inventoryRef,userType):
	var sts = Status.new()
	sts.inventory = inventoryRef
	sts.userType = userType
	if userType.has("born_status"):
		sts.setStatus(userType.born_status.duplicate(true))
	if userType.has("born_status_max"):
		sts.setStatusMax(userType.born_status_max.duplicate(true))
	if userType.has("born_effect"):
		sts.setEffect(userType.born_effect.duplicate(true))
	if userType.has("born_effect_consum"):
		sts.setEffectConum(userType.born_effect_consum.duplicate(true))
	if userType.has("born_regen"):
		sts.setNaturalRegen(userType.born_regen.duplicate(true))
	if userType.has("born_status_def"):
		sts.setStatusDef(userType.born_status_def.duplicate(true))
	return sts

func setStatusMax(stts):
	status_max = stts

func setStatus(stts):
	status = stts

func setStatusDef(stts):
	status_def = stts

func setEffect(eff):
	effect = eff

func setEffectConum(consum):
	effectConsum = consum

func setNaturalRegen(reg):
	naturalRegen = reg

func getLifeState():
	return float(status[0])/float(status_max[0])

func getEffect():
	return effect

func getDefense():
	return status_def

func getConsumStatus():
	return effectConsum

func activeRegen():
	applyEffect(naturalRegen)

func lifeState():
	return status[0]

func applyOnStatus(sts,value):
	if status[sts] + value > status_max[sts]:
		status[sts] = status_max[sts]
	else:
		print(status)
		status[sts] += value
	if sts == 0:
		emit_signal("lifeChange")
		if value < 0:
			emit_signal("lifeLoss")
			if status[sts] <= 0:
				status[sts] = 0
				emit_signal("lifeIsZero")
		elif value > 0:
			emit_signal("lifeGain")
			if status[sts] == status_max[sts]:
				emit_signal("lifeIsFull")

func applyEffect(effect):
	for sts in status.size():
		applyOnStatus(sts,effect[sts])

func consumStatus():
	var stsConsumable = inventory.getItemConsumableStatus()
	
	for idx in stsConsumable.size():
		stsConsumable[idx] += effectConsum[idx]
	
	for sts in status.size():
		applyOnStatus(sts,stsConsumable[sts])
