extends Node

class_name MetricasDeEstatisticas

static func createMetricHabilidadeUse(habilidade, justMoviment:bool=false):
	if justMoviment: 
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.USO_HABILIDADE,{
			'cause':"Movimento",
			'value':null,
			'agent':habilidade
		})
	else:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.USO_HABILIDADE,{
			'cause':"Habilidade " + ("fisica" if habilidade.type == "fisico" else "mágica"),
			'value':null,
			'agent':habilidade.get_nome()
		})
static func createMetricConsumoDeEnergia(agent,byHability:bool=true):
	return Estatisticas.createCombateMetric(Estatisticas.COMBATE.ENERGIA_GASTA,{
		'cause':"Consumo de energia por " + ("habilidade" if byHability else "itens"),
		'value':null,
		'agent':agent
	})
static func createMetricDanoRecebido(cause,agent,value=null,type_magic:bool=true):
	if type_magic:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_RECEBIDO,{
			'cause':"Habilidade Mágica "+cause.type.nome,
			'value':value,
			'agent':agent.type.nome
		})
	else:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_RECEBIDO,{
			'cause':cause,
			'value':value,
			'agent':agent
		})
static func createMetricDanoCausado(cause,agent,value=null,type_magic:bool=true):
	if type_magic:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_CAUSADO,{
			'cause':"Habilidade Mágica "+cause.type.nome,
			'value':value,
			'agent':agent.type.nome
		})
	else:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.DANO_CAUSADO,{
			'cause':cause,
			'value':value,
			'agent':agent
		})
static func createMetricEliminacoes(cause,agent,value=null,type_magic:bool=true):
	if type_magic:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.ELIMINACOES,{
			'cause':"Habilidade Mágica "+cause.type.nome,
			'value':value,
			'agent':agent.type.nome
		})
	else:
		return Estatisticas.createCombateMetric(Estatisticas.COMBATE.ELIMINACOES,{
			'cause':cause,
			'value':value,
			'agent':agent
		})
static func createMetricMorte(cause,value,agent):
	return Estatisticas.createCombateMetric(Estatisticas.COMBATE.MORTES,{
		'cause':cause,
		'value':value,
		'agent':agent
	})
