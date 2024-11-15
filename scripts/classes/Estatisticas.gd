extends Node

class_name Estatisticas

enum ESTATISTICAS_GROUP {GERAL,DETALHADO}
enum ESTATISTICAS_CLASS {COMBATE,EXPLORACAO,ITENS,ECONOMIA,RELACOES}
enum COMBATE {MORTES,ELIMINACOES,DANO_RECEBIDO,MAIOR_DANO_RECEBIDO,DANO_CAUSADO,MAIOR_DANO_CAUSADO,USO_HABILIDADE,ENERGIA_GASTA}
enum EXPLORACAO {TEMPO,BIOMAS_EXPLORADOS,DISTANCIA_PERCORRIDA,TRANSPORTES_USADO}
enum ITENS {COLETADOS,CRAFTADOS,DESTRUIDOS,COLOCADOS,GANHOS,PERDIDOS,ROUBADOS,ACHADOS,ENTREGUES,EXTRAIDOS,ARMAZENADOS,DADOS}
enum ECONOMIA {RECOMPENSAS_GANHAS,RECOMPENSAS_PERDIDAS,RECOMPENSAS_RECUSADAS,RECOMPENSAS_DOADAS,TROCAS_REALIZADAS,MAIOR_DEBITO,MAIOR_DEBITO_PAGO}
enum RELACOES {MISSOES_CUMPRIDAS,MISSOES_ABANDONADAS,MISSOES_RECUSADAS,MISSOES_FALHAS,MISSOES_INTERROMPIDAS}

var estatisticas : Dictionary = {
	ESTATISTICAS_GROUP.GERAL: {
		ESTATISTICAS_CLASS.COMBATE : {
			COMBATE.MORTES:0,
			COMBATE.ELIMINACOES:0,
			COMBATE.DANO_RECEBIDO:0,
			COMBATE.MAIOR_DANO_RECEBIDO:0,
			COMBATE.DANO_CAUSADO:0,
			COMBATE.MAIOR_DANO_CAUSADO:0,
			COMBATE.USO_HABILIDADE:0,
			COMBATE.ENERGIA_GASTA:0
		},
		ESTATISTICAS_CLASS.EXPLORACAO : {
			EXPLORACAO.TEMPO:0,
			EXPLORACAO.BIOMAS_EXPLORADOS:0,
			EXPLORACAO.DISTANCIA_PERCORRIDA:0,
			EXPLORACAO.TRANSPORTES_USADO:0
		},
		ESTATISTICAS_CLASS.ITENS:{
			ITENS.COLETADOS:0,
			ITENS.CRAFTADOS:0,
			ITENS.DESTRUIDOS:0,
			ITENS.COLOCADOS:0,
			ITENS.GANHOS:0,
			ITENS.PERDIDOS:0,
			ITENS.ROUBADOS:0,
			ITENS.ACHADOS:0,
			ITENS.ENTREGUES:0,
			ITENS.EXTRAIDOS:0,
			ITENS.ARMAZENADOS:0,
			ITENS.DADOS:0
		},
		ESTATISTICAS_CLASS.ECONOMIA:{
			ECONOMIA.RECOMPENSAS_GANHAS:0,
			ECONOMIA.RECOMPENSAS_PERDIDAS:0,
			ECONOMIA.RECOMPENSAS_RECUSADAS:0,
			ECONOMIA.RECOMPENSAS_DOADAS:0,
			ECONOMIA.TROCAS_REALIZADAS:0,
			ECONOMIA.MAIOR_DEBITO:0,
			ECONOMIA.MAIOR_DEBITO_PAGO:0
		},
		ESTATISTICAS_CLASS.RELACOES:{
			RELACOES.MISSOES_CUMPRIDAS:0,
			RELACOES.MISSOES_ABANDONADAS:0,
			RELACOES.MISSOES_RECUSADAS:0,
			RELACOES.MISSOES_FALHAS:0,
			RELACOES.MISSOES_INTERROMPIDAS:0
		}
	},
	ESTATISTICAS_GROUP.DETALHADO : {
		ESTATISTICAS_CLASS.COMBATE : {
			COMBATE.MORTES:[],
			COMBATE.ELIMINACOES:[],
			COMBATE.DANO_RECEBIDO:[],
			COMBATE.MAIOR_DANO_RECEBIDO:[],
			COMBATE.DANO_CAUSADO:[],
			COMBATE.MAIOR_DANO_CAUSADO:[],
			COMBATE.USO_HABILIDADE:[],
			COMBATE.ENERGIA_GASTA:[]
		},
		ESTATISTICAS_CLASS.EXPLORACAO : {
			EXPLORACAO.TEMPO:[],
			EXPLORACAO.BIOMAS_EXPLORADOS:[],
			EXPLORACAO.DISTANCIA_PERCORRIDA:[],
			EXPLORACAO.TRANSPORTES_USADO:[]
		},
		ESTATISTICAS_CLASS.ITENS:{
			ITENS.COLETADOS:[],
			ITENS.CRAFTADOS:[],
			ITENS.DESTRUIDOS:[],
			ITENS.COLOCADOS:[],
			ITENS.GANHOS:[],
			ITENS.PERDIDOS:[],
			ITENS.ROUBADOS:[],
			ITENS.ACHADOS:[],
			ITENS.ENTREGUES:[],
			ITENS.EXTRAIDOS:[],
			ITENS.ARMAZENADOS:[],
			ITENS.DADOS:[]
		},
		ESTATISTICAS_CLASS.ECONOMIA:{
			ECONOMIA.RECOMPENSAS_GANHAS:[],
			ECONOMIA.RECOMPENSAS_PERDIDAS:[],
			ECONOMIA.RECOMPENSAS_RECUSADAS:[],
			ECONOMIA.RECOMPENSAS_DOADAS:[],
			ECONOMIA.TROCAS_REALIZADAS:[],
			ECONOMIA.MAIOR_DEBITO:[],
			ECONOMIA.MAIOR_DEBITO_PAGO:[]
		},
		ESTATISTICAS_CLASS.RELACOES:{
			RELACOES.MISSOES_CUMPRIDAS:[],
			RELACOES.MISSOES_ABANDONADAS:[],
			RELACOES.MISSOES_RECUSADAS:[],
			RELACOES.MISSOES_FALHAS:[],
			RELACOES.MISSOES_INTERROMPIDAS:[]
		}
	}
}

func addStatisticMorte(statistic):
	#print(COMBATE.find_key(COMBATE.MORTES),statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MORTES] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MORTES,statistic) # [causa da morte, ---, causador da morte]

func addStatisticEliminacao(statistic):
	#print(COMBATE.find_key(COMBATE.ELIMINACOES),statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.ELIMINACOES] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.ELIMINACOES,statistic) # [Como matou, ---, quem causou]

func addStatisticDanoRecebido(statistic):
	if statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.DANO_RECEBIDO),statistic)
		var v = estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_RECEBIDO]
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_RECEBIDO] = max(v,abs(statistic.value))
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MAIOR_DANO_RECEBIDO,statistic) # [Tipos de dano, valor, quem causou]
		
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.DANO_RECEBIDO] += abs(statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.DANO_RECEBIDO,statistic) # [Tipos de dano, valor, quem causou]

func addStatisticDanoCausado(statistic):
	if statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.DANO_CAUSADO),statistic)
		var v = estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_CAUSADO]
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.MAIOR_DANO_CAUSADO] = max(v,abs(statistic.value))
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.MAIOR_DANO_CAUSADO,statistic) # [Tipos de dano, valor, quem causou]

		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.DANO_CAUSADO] += abs(statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.DANO_CAUSADO,statistic) # [Tipos de dano, valor, quem causou]

func addStatisticUsoHabilidade(statistic):
	#print(COMBATE.find_key(COMBATE.USO_HABILIDADE),statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.USO_HABILIDADE] += 1
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.USO_HABILIDADE,statistic) # [Tipos de habilidade, ---, habilidade]

func addStatisticEnergiaGasta(statistic):
	if statistic.value != 0:
		#print(COMBATE.find_key(COMBATE.ENERGIA_GASTA), statistic)
		estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.COMBATE][COMBATE.ENERGIA_GASTA] += abs(statistic.value)
		addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.COMBATE,COMBATE.ENERGIA_GASTA,statistic) # [Tipos de energia, valor, habilidade]

func addStatisticTempo(statistic):
	pass
func addStatisticBiomasExplorados(statistic):
	pass
func addStatisticDistanciaPercorrida(statistic):
	pass
func addStatisticTransportesUsado(statistic):
	pass

func addStatisticColetados(statistic):
	#print(ITENS.find_key(ITENS.COLETADOS), statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.ITENS][ITENS.COLETADOS] += statistic.value
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.ITENS,ITENS.COLETADOS,statistic) # [Tipos de item, quantidade, item]

func addStatisticCraftados(statistic):
	#print(ITENS.find_key(ITENS.CRAFTADOS), statistic)
	estatisticas[ESTATISTICAS_GROUP.GERAL][ESTATISTICAS_CLASS.ITENS][ITENS.CRAFTADOS] += statistic.value
	addStatistic(ESTATISTICAS_GROUP.DETALHADO,ESTATISTICAS_CLASS.ITENS,ITENS.CRAFTADOS,statistic) # [Tipos de item, quantidade, item]

func addStatisticDestruidos(statistic):
	pass
func addStatisticColocados(statistic):
	pass
func addStatisticGanhos(statistic):
	pass
func addStatisticPerdidos(statistic):
	pass
func addStatisticRoubados(statistic):
	pass
func addStatisticAchados(statistic):
	pass
func addStatisticEntregues(statistic):
	pass
func addStatisticExtraidos(statistic):
	pass
func addStatisticArmazenados(statistic):
	pass
func addStatisticDados(statistic):
	pass
func addStatisticRecompensasGanhas(statistic):
	pass
func addStatisticRecompensasPerdidas(statistic):
	pass
func addStatisticRecompensasRecusadas(statistic):
	pass
func addStatisticRecompensasDoadas(statistic):
	pass
func addStatisticTrocasRealizadas(statistic):
	pass
func addStatisticMaiorDebito(statistic):
	pass
func addStatisticMaiorDebitoPago(statistic):
	pass
func addStatisticMissoesCumpridas(statistic):
	pass
func addStatisticMissoesRecusadas(statistic):
	pass
func addStatisticMissoesAbandonadas(statistic):
	pass
func addStatisticMissoesFalhas(statistic):
	pass
func addStatisticMissoesInterrompidas(statistic):
	pass

func addStatistic(group_statistic,class_statistic,metric,statistic):
	estatisticas[group_statistic][class_statistic][metric].append(statistic)

func hasThisCombatStatistic(group,lookAt,countBy,value):
	var result = 0
	for ek in estatisticas[group][ESTATISTICAS_CLASS.COMBATE].keys():
		for e in estatisticas[group][ESTATISTICAS_CLASS.COMBATE][ek].size():
			if estatisticas[group][ESTATISTICAS_CLASS.COMBATE][ek][e][lookAt] == countBy:
				var metric = estatisticas[group][ESTATISTICAS_CLASS.COMBATE][ek][e]
				result += metric.value if metric.value != null else 1
	return result > value

static func encapsuleStatistic(statistic):
	return {
		'cause':statistic.cause,
		'value':abs(statistic.value) if statistic.value != null else null,
		'agent':statistic.agent
	}
#func validateMetric(statistic):
	#if statistic.metric == 
