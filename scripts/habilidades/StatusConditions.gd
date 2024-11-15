extends Node

enum END_EFFECT_CONDITION {TIME_END,DIE,COUNTEREFFECT}

signal effect_actived(eff)
signal effect_applyed(eff)
signal effect_canceled(eff)

#Tempo de duração do efeito
var duration_time : int # in seconds
# 0 - instant effect
# < 0 - conditional end effect
# > 0 - temporary effect
#Tempo entre aplicação de efeito
var apply_cooldown : int # in seconds
# > duration_time - aplicação unica
# < duration_time - aplicação repetitiva
var actual_time : int = 0
var counter_effect : String #Efeito de cancelamento
var effect_rank : String

var condition_end_effect : END_EFFECT_CONDITION
var status_effect : Status

func _process(delta: float) -> void:
	if actual_time%apply_cooldown == 0:
		emit_signal("effect_applyed",self)
	if actual_time >= duration_time:
		emit_signal("effect_canceled",self)
	else:
		actual_time += 1

func upgradeEffect():
	pass

func downgradeEffect():
	pass
