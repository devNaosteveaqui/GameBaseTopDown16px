extends Area2D

class_name HAreaEffect

var spawn_count : int = 0
var time_cooldown : int = 2
var can_target_caster : bool = false
var spawn_max : int
var hab_effect
var type
var caster

func _ready():
	$Timer.start(time_cooldown)
	$Timer.connect("timeout",spawnEntity)

func spawnEntity():
	if spawn_count < spawn_max:
		var targets = get_overlapping_bodies()
		for t in targets.size():
			if not(targets[t] == caster and not can_target_caster):
				var statistic_dano_recebido : Dictionary = {
					'metric':Estatisticas.COMBATE.DANO_RECEBIDO,
					'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
					'cause':"Habilidade Mágica "+type.nome,
					'agent':caster.type.nome
				}
				var statistic_dano_causado : Dictionary = {
					'metric':Estatisticas.COMBATE.DANO_CAUSADO,
					'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
					'cause':"Habilidade Mágica "+type.nome,
					'value':hab_effect[0],
					'agent':targets[t].type.nome
				
				}
				var statistic_eliminacao : Dictionary = {
					'metric':Estatisticas.COMBATE.ELIMINACOES,
					'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
					'cause':"Habilidade Mágica "+type.nome,
					'value':hab_effect[0],
					'agent':targets[t].type.nome
				}
				caster.update_statistic(statistic_dano_causado)
				SystemBattle.apply_effect_on(statistic_dano_recebido,hab_effect,targets[t])
				#targets[t].try_apply_effect(statistic_dano_recebido,hab_effect)
				if targets[t] == null:
					caster.update_statistic(statistic_eliminacao)
		spawn_count += 1
	else:
		queue_free()
