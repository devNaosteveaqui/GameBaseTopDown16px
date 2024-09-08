extends Node

enum END_EFFECT_CONDITION {TIME_END,DIE,COUNTEREFFECT}

var duration_time : int # in seconds
# 0 - instant effect
# < 0 - conditional end effect
# > 0 - temporary effect
var apply_cooldown : int # in seconds
var actual_time : int = 0
var counter_effect : String
var effect_rank : String

var condition_end_effect : END_EFFECT_CONDITION
var status_effect : Status
var target

func upgradeEffect():
	pass
func downgradeEffect():
	pass
