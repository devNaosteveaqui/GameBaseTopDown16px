extends Area2D

class_name HProjetil

@export var timer : Timer

var caster : Entity
var dir : Vector2
var speed : int = 0
var hab_effect : Array
var timer_duration : int
var type
var can_target_caster : bool = false

func _ready() -> void:
	self.body_entered.connect(collisionOnBody)
	timer.timeout.connect(dispel)
	timer.start(timer_duration)
	speed = 200

func _physics_process(delta: float) -> void:
	position = position + dir*speed*delta

func collisionOnBody(body):
	if caster == null:
		return
	if not(body == caster and not can_target_caster):
		var statistic_dano_recebido : Dictionary = MetricasDeEstatisticas.createMetricDanoRecebido(self,caster,null)
		var statistic_dano_causado : Dictionary = MetricasDeEstatisticas.createMetricDanoCausado(self,body,hab_effect[0])
		var statistic_eliminacao : Dictionary = MetricasDeEstatisticas.createMetricEliminacoes(self,body,hab_effect[0])
		#var statistic_dano_recebido : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_RECEBIDO,{'cause':"Habilidade Mágica "+type.nome,'value':null,'agent':caster.type.nome})
		#var statistic_dano_causado : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_CAUSADO,{'cause':"Habilidade Mágica "+type.nome,'value':hab_effect[0],'agent':body.type.nome})
		#var statistic_eliminacao : Dictionary = Estatisticas.createCombateMetric(Estatisticas.COMBATE.ELIMINACOES,{'cause':"Habilidade Mágica "+type.nome,'value':hab_effect[0],'agent':body.type.nome})
		
		caster.update_statistic(statistic_dano_causado)
		SystemBattle.apply_effect_on(statistic_dano_recebido,hab_effect,body)
		#body.try_apply_effect(statistic_dano_recebido,hab_effect)
		if body == null:
			caster.update_statistic(statistic_eliminacao)
		#body.tryApplyStatusCondition()
		dispel()

func dispel():
	queue_free()
