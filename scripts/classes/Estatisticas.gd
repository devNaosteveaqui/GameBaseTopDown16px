extends Node

class_name Estatisticas

enum ESTATISTICAS_GROUP {GERAL,DETALHADO}
enum ESTATISTICAS_CLASS {COMBATE,EXPLORACAO,ITENS,ECONOMIA,RELACOES}
enum COMBATE {MORTES,ELIMINACOES,DANO_RECEBIDO,MAIOR_DANO_RECEBIDO,DANO_CAUSADO,MAIOR_DANO_CAUSADO,USO_HABILIDADE,ENERGIA_GASTA}
enum EXPLORACAO {TEMPO,BIOMAS_EXPLORADOS,DISTANCIA_PERCORRIDA,TRANSPORTES_USADO}
enum ITENS {COLETADOS,CRAFTADOS,DESTRUIDOS,COLOCADOS,GANHOS,PERDIDOS,ROUBADOS,ACHADOS,ENTREGUES,EXTRAIDOS,ARMAZENADOS,DADOS}
enum ECONOMIA {RECOMPENSAS_GANHAS,RECOMPENSAS_PERDIDAS,RECOMPENSAS_RECUSADAS,RECOMPENSAS_DOADAS,TROCAS_REALIZADAS,MAIOR_DEBITO,MAIOR_DEBITO_PAGO}
enum RELACOES {MISSOES_CUMPRIDAS,MISSOES_ABANDONADAS,MISSOES_RECUSADAS,MISSOES_FALHAS,MISSOES_INTERROMPIDAS}

const enums = {
	Estatisticas.ESTATISTICAS_CLASS.COMBATE : Estatisticas.COMBATE,
	Estatisticas.ESTATISTICAS_CLASS.EXPLORACAO : Estatisticas.EXPLORACAO,
	Estatisticas.ESTATISTICAS_CLASS.ITENS : Estatisticas.ITENS,
	Estatisticas.ESTATISTICAS_CLASS.ECONOMIA : Estatisticas.ECONOMIA,
	Estatisticas.ESTATISTICAS_CLASS.RELACOES : Estatisticas.RELACOES
}

const labels = {
	Estatisticas.COMBATE : {
		Estatisticas.COMBATE.MORTES : "Mortes",
		Estatisticas.COMBATE.ELIMINACOES : "Eliminações",
		Estatisticas.COMBATE.DANO_RECEBIDO : "Dano recebido",
		Estatisticas.COMBATE.MAIOR_DANO_RECEBIDO : "Maior dano recebido",
		Estatisticas.COMBATE.DANO_CAUSADO : "Dano causado",
		Estatisticas.COMBATE.MAIOR_DANO_CAUSADO : "Maior Dano causado",
		Estatisticas.COMBATE.USO_HABILIDADE : "Uso de Habilidade",
		Estatisticas.COMBATE.ENERGIA_GASTA : "Energia Gasta"
	},
	Estatisticas.EXPLORACAO : {
		Estatisticas.EXPLORACAO.TEMPO : "Tempo",
		Estatisticas.EXPLORACAO.BIOMAS_EXPLORADOS : "Biomas Explorados",
		Estatisticas.EXPLORACAO.DISTANCIA_PERCORRIDA : "Distancia Percorrida",
		Estatisticas.EXPLORACAO.TRANSPORTES_USADO : "Transportes Usados"
	},
	Estatisticas.ITENS : {
		Estatisticas.ITENS.COLETADOS : "Coletados",
		Estatisticas.ITENS.CRAFTADOS : "Craftados",
		Estatisticas.ITENS.DESTRUIDOS : "Destruidos",
		Estatisticas.ITENS.COLOCADOS : "Colocados",
		Estatisticas.ITENS.GANHOS : "Ganhos",
		Estatisticas.ITENS.PERDIDOS : "Perdidos",
		Estatisticas.ITENS.ROUBADOS : "Roubados",
		Estatisticas.ITENS.ACHADOS : "Achados",
		Estatisticas.ITENS.ENTREGUES : "Entregues",
		Estatisticas.ITENS.EXTRAIDOS : "Extraídos",
		Estatisticas.ITENS.ARMAZENADOS : "Armazenados",
		Estatisticas.ITENS.DADOS : "Dados"
	},
	Estatisticas.ECONOMIA : {
		Estatisticas.ECONOMIA.RECOMPENSAS_GANHAS : "Recompensas ganhas",
		Estatisticas.ECONOMIA.RECOMPENSAS_PERDIDAS : "Recompensas perdidas",
		Estatisticas.ECONOMIA.RECOMPENSAS_RECUSADAS : "Recompensas recusadas",
		Estatisticas.ECONOMIA.RECOMPENSAS_DOADAS : "Recompensas doadas",
		Estatisticas.ECONOMIA.TROCAS_REALIZADAS : "Trocas realizadas",
		Estatisticas.ECONOMIA.MAIOR_DEBITO : "Maior debito",
		Estatisticas.ECONOMIA.MAIOR_DEBITO_PAGO : "Maior debito pago"
	},
	Estatisticas.RELACOES : {
		Estatisticas.RELACOES.MISSOES_CUMPRIDAS : "Missões cumpridas",
		Estatisticas.RELACOES.MISSOES_ABANDONADAS : "Missões abandonadas",
		Estatisticas.RELACOES.MISSOES_RECUSADAS : "Missões recusadas",
		Estatisticas.RELACOES.MISSOES_FALHAS : "Missões falhas",
		Estatisticas.RELACOES.MISSOES_INTERROMPIDAS : "Missões interrompidas"
	}
}

var estatisticas : Dictionary = {
	Estatisticas.ESTATISTICAS_GROUP.GERAL: {
		Estatisticas.ESTATISTICAS_CLASS.COMBATE : {
			Estatisticas.COMBATE.MORTES:0,
			Estatisticas.COMBATE.ELIMINACOES:0,
			Estatisticas.COMBATE.DANO_RECEBIDO:0,
			Estatisticas.COMBATE.MAIOR_DANO_RECEBIDO:0,
			Estatisticas.COMBATE.DANO_CAUSADO:0,
			Estatisticas.COMBATE.MAIOR_DANO_CAUSADO:0,
			Estatisticas.COMBATE.USO_HABILIDADE:0,
			Estatisticas.COMBATE.ENERGIA_GASTA:0
		},
		Estatisticas.ESTATISTICAS_CLASS.EXPLORACAO : {
			Estatisticas.EXPLORACAO.TEMPO:0,
			Estatisticas.EXPLORACAO.BIOMAS_EXPLORADOS:0,
			Estatisticas.EXPLORACAO.DISTANCIA_PERCORRIDA:0,
			Estatisticas.EXPLORACAO.TRANSPORTES_USADO:0
		},
		Estatisticas.ESTATISTICAS_CLASS.ITENS:{
			Estatisticas.ITENS.COLETADOS:0,
			Estatisticas.ITENS.CRAFTADOS:0,
			Estatisticas.ITENS.DESTRUIDOS:0,
			Estatisticas.ITENS.COLOCADOS:0,
			Estatisticas.ITENS.GANHOS:0,
			Estatisticas.ITENS.PERDIDOS:0,
			Estatisticas.ITENS.ROUBADOS:0,
			Estatisticas.ITENS.ACHADOS:0,
			Estatisticas.ITENS.ENTREGUES:0,
			Estatisticas.ITENS.EXTRAIDOS:0,
			Estatisticas.ITENS.ARMAZENADOS:0,
			Estatisticas.ITENS.DADOS:0
		},
		Estatisticas.ESTATISTICAS_CLASS.ECONOMIA:{
			Estatisticas.ECONOMIA.RECOMPENSAS_GANHAS:0,
			Estatisticas.ECONOMIA.RECOMPENSAS_PERDIDAS:0,
			Estatisticas.ECONOMIA.RECOMPENSAS_RECUSADAS:0,
			Estatisticas.ECONOMIA.RECOMPENSAS_DOADAS:0,
			Estatisticas.ECONOMIA.TROCAS_REALIZADAS:0,
			Estatisticas.ECONOMIA.MAIOR_DEBITO:0,
			Estatisticas.ECONOMIA.MAIOR_DEBITO_PAGO:0
		},
		Estatisticas.ESTATISTICAS_CLASS.RELACOES:{
			Estatisticas.RELACOES.MISSOES_CUMPRIDAS:0,
			Estatisticas.RELACOES.MISSOES_ABANDONADAS:0,
			Estatisticas.RELACOES.MISSOES_RECUSADAS:0,
			Estatisticas.RELACOES.MISSOES_FALHAS:0,
			Estatisticas.RELACOES.MISSOES_INTERROMPIDAS:0
		}
	},
	Estatisticas.ESTATISTICAS_GROUP.DETALHADO : {
		Estatisticas.ESTATISTICAS_CLASS.COMBATE : {
			Estatisticas.COMBATE.MORTES:[],
			Estatisticas.COMBATE.ELIMINACOES:[],
			Estatisticas.COMBATE.DANO_RECEBIDO:[],
			Estatisticas.COMBATE.MAIOR_DANO_RECEBIDO:[],
			Estatisticas.COMBATE.DANO_CAUSADO:[],
			Estatisticas.COMBATE.MAIOR_DANO_CAUSADO:[],
			Estatisticas.COMBATE.USO_HABILIDADE:[],
			Estatisticas.COMBATE.ENERGIA_GASTA:[]
		},
		Estatisticas.ESTATISTICAS_CLASS.EXPLORACAO : {
			Estatisticas.EXPLORACAO.TEMPO:[],
			Estatisticas.EXPLORACAO.BIOMAS_EXPLORADOS:[],
			Estatisticas.EXPLORACAO.DISTANCIA_PERCORRIDA:[],
			Estatisticas.EXPLORACAO.TRANSPORTES_USADO:[]
		},
		Estatisticas.ESTATISTICAS_CLASS.ITENS:{
			Estatisticas.ITENS.COLETADOS:[],
			Estatisticas.ITENS.CRAFTADOS:[],
			Estatisticas.ITENS.DESTRUIDOS:[],
			Estatisticas.ITENS.COLOCADOS:[],
			Estatisticas.ITENS.GANHOS:[],
			Estatisticas.ITENS.PERDIDOS:[],
			Estatisticas.ITENS.ROUBADOS:[],
			Estatisticas.ITENS.ACHADOS:[],
			Estatisticas.ITENS.ENTREGUES:[],
			Estatisticas.ITENS.EXTRAIDOS:[],
			Estatisticas.ITENS.ARMAZENADOS:[],
			Estatisticas.ITENS.DADOS:[]
		},
		Estatisticas.ESTATISTICAS_CLASS.ECONOMIA:{
			Estatisticas.ECONOMIA.RECOMPENSAS_GANHAS:[],
			Estatisticas.ECONOMIA.RECOMPENSAS_PERDIDAS:[],
			Estatisticas.ECONOMIA.RECOMPENSAS_RECUSADAS:[],
			Estatisticas.ECONOMIA.RECOMPENSAS_DOADAS:[],
			Estatisticas.ECONOMIA.TROCAS_REALIZADAS:[],
			Estatisticas.ECONOMIA.MAIOR_DEBITO:[],
			Estatisticas.ECONOMIA.MAIOR_DEBITO_PAGO:[]
		},
		Estatisticas.ESTATISTICAS_CLASS.RELACOES:{
			Estatisticas.RELACOES.MISSOES_CUMPRIDAS:[],
			Estatisticas.RELACOES.MISSOES_ABANDONADAS:[],
			Estatisticas.RELACOES.MISSOES_RECUSADAS:[],
			Estatisticas.RELACOES.MISSOES_FALHAS:[],
			Estatisticas.RELACOES.MISSOES_INTERROMPIDAS:[]
		}
	}
}

func addStatisticMorte(_statistic):
	#print(COMBATE.find_key(COMBATE.MORTES),_statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MORTES] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MORTES,_statistic) # [causa da morte, ---, causador da morte]

func addStatisticEliminacao(_statistic):
	#print(COMBATE.find_key(COMBATE.ELIMINACOES),_statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.ELIMINACOES] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.ELIMINACOES,_statistic) # [Como matou, ---, quem causou]

func addStatisticDanoRecebido(_statistic):
	if _statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.DANO_RECEBIDO),_statistic)
		var v = estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_RECEBIDO]
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_RECEBIDO] = max(v,abs(_statistic.value))
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MAIOR_DANO_RECEBIDO,_statistic) # [Tipos de dano, valor, quem causou]
		
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.DANO_RECEBIDO] += abs(_statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.DANO_RECEBIDO,_statistic) # [Tipos de dano, valor, quem causou]

func addStatisticDanoCausado(_statistic):
	if _statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.DANO_CAUSADO),_statistic)
		var v = estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_CAUSADO]
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_CAUSADO] = max(v,abs(_statistic.value))
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MAIOR_DANO_CAUSADO,_statistic) # [Tipos de dano, valor, quem causou]

		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.DANO_CAUSADO] += abs(_statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.DANO_CAUSADO,_statistic) # [Tipos de dano, valor, quem causou]

func addStatisticUsoHabilidade(_statistic):
	#print(COMBATE.find_key(COMBATE.USO_HABILIDADE),_statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.USO_HABILIDADE] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.USO_HABILIDADE,_statistic) # [Tipos de habilidade, ---, habilidade]

func addStatisticEnergiaGasta(_statistic):
	if _statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.ENERGIA_GASTA), _statistic)
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.ENERGIA_GASTA] += abs(_statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.ENERGIA_GASTA,_statistic) # [Tipos de energia, valor, habilidade]

func addStatisticTempo(_statistic):
	pass
func addStatisticBiomasExplorados(_statistic):
	pass
func addStatisticDistanciaPercorrida(_statistic):
	pass
func addStatisticTransportesUsado(_statistic):
	pass

func addStatisticColetados(_statistic):
	#print(ITENS.find_key(ITENS.COLETADOS), _statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.ITENS][ITENS.COLETADOS] += _statistic.value
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.ITENS,ITENS.COLETADOS,_statistic) # [Tipos de item, quantidade, item]

func addStatisticCraftados(_statistic):
	#print(ITENS.find_key(ITENS.CRAFTADOS), _statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.ITENS][ITENS.CRAFTADOS] += _statistic.value
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.ITENS,ITENS.CRAFTADOS,_statistic) # [Tipos de item, quantidade, item]

func addStatisticDestruidos(_statistic):
	pass
func addStatisticColocados(_statistic):
	pass
func addStatisticGanhos(_statistic):
	pass
func addStatisticPerdidos(_statistic):
	pass
func addStatisticRoubados(_statistic):
	pass
func addStatisticAchados(_statistic):
	pass
func addStatisticEntregues(_statistic):
	pass
func addStatisticExtraidos(_statistic):
	pass
func addStatisticArmazenados(_statistic):
	pass
func addStatisticDados(_statistic):
	pass
func addStatisticRecompensasGanhas(_statistic):
	pass
func addStatisticRecompensasPerdidas(_statistic):
	pass
func addStatisticRecompensasRecusadas(_statistic):
	pass
func addStatisticRecompensasDoadas(_statistic):
	pass
func addStatisticTrocasRealizadas(_statistic):
	pass
func addStatisticMaiorDebito(_statistic):
	pass
func addStatisticMaiorDebitoPago(_statistic):
	pass
func addStatisticMissoesCumpridas(_statistic):
	pass
func addStatisticMissoesRecusadas(_statistic):
	pass
func addStatisticMissoesAbandonadas(_statistic):
	pass
func addStatisticMissoesFalhas(_statistic):
	pass
func addStatisticMissoesInterrompidas(_statistic):
	pass

#Função interna
func addStatistic(group_statistic,class_statistic,metric,_statistic):
	estatisticas[group_statistic][class_statistic][metric].append(_statistic)

#group : estatisticas gerais ou detalhadas
#lookAt : propriedade de estatistica observada
#	'cause' (causa do evento), 'value' (valor do evento), 'agent' (alvo ou agente da estatisticas)
func hasThisCombatStatistic(group,lookAt,countBy,value):
	var result = 0
	for combat_estatistics_key in estatisticas[group][ESTATISTICAS_CLASS.COMBATE].keys():
		for e in estatisticas[group][ESTATISTICAS_CLASS.COMBATE][combat_estatistics_key].size():
			if hasStatisticsAttribute(estatisticas[group][ESTATISTICAS_CLASS.COMBATE][combat_estatistics_key][e][lookAt],countBy):
				var metric = estatisticas[group][ESTATISTICAS_CLASS.COMBATE][combat_estatistics_key][e]
				result += metric.value if metric.value != null else 1 #Para contagem de valores soma-se, caso contrário contase a unidade
	return result > value

func hasStatisticsAttribute(agent,looked):
	return agent == looked

static func encapsuleStatistic(_statistic):
	return {
		'cause':_statistic.cause,
		'value':abs(_statistic.value) if _statistic.value != null else null,
		'agent':_statistic.agent
	}
static func createItemMetric(metric,item=null):
	return {
		'metric':metric,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.ITENS,
		'cause':ItemInterface.get_class_statistic(item) if item!=null else null,
		'value':ItemInterface.get_quantity(item) if item!=null else null,
		'agent':ItemInterface.get_item_nome(item) if item!=null else null
	}
static func createCombateMetric(metric,args={'cause':null,'value':null,'agent':null}):
	return {
		'metric':metric,
		'metric_class':Estatisticas.ESTATISTICAS_CLASS.COMBATE,
		'cause':args.cause if args['cause'] != null else null,
		'value':args.value if args['value'] != null else null,
		'agent':args.agent if args['agent'] != null else null
	}
#func validateMetric(_statistic):
	#if _statistic.metric == 

func update_statistic(_statistic):
	if not _statistic.keys().has('metric_class'):
		return
	if _statistic.metric_class == Estatisticas.ESTATISTICAS_CLASS.ITENS:
		if _statistic.metric == Estatisticas.ITENS.COLETADOS:
			addStatisticColetados(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.ITENS.CRAFTADOS:
			addStatisticCraftados(Estatisticas.encapsuleStatistic(_statistic))
	elif _statistic.metric_class == Estatisticas.ESTATISTICAS_CLASS.COMBATE:
		if _statistic.metric == Estatisticas.COMBATE.ENERGIA_GASTA:
			addStatisticEnergiaGasta(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.COMBATE.DANO_RECEBIDO:
			addStatisticDanoRecebido(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.COMBATE.DANO_CAUSADO:
			addStatisticDanoCausado(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.COMBATE.MORTES:
			addStatisticMorte(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.COMBATE.USO_HABILIDADE:
			addStatisticUsoHabilidade(Estatisticas.encapsuleStatistic(_statistic))
		elif _statistic.metric == Estatisticas.COMBATE.ELIMINACOES:
			addStatisticEliminacao(Estatisticas.encapsuleStatistic(_statistic))
	else:#unequip, ConsumDrop, spawnStorage
		pass
