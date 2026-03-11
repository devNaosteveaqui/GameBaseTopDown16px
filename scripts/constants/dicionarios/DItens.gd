extends Node

class_name Itens

const TRONCO = {
	'nome' : 'Tronco de Árvore',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Bom, todo item de madeira precisa vir de algum lugar, por exemplo... um tronco de árvore talvez?",
	'sprite' : 'madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural vegetal",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const PEDRA = {
	'nome' : 'Pedra',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Já viu uma Pedra?",
	'sprite' : 'pedra.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural mineral",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const FRUTA_VERMELHA = {
	'nome' : 'Fruta Vermelha',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Uma fruta estranha, não é morango e nem maçã mas é vermelha e estranhamente restaura sua vida?",
	'sprite' : 'frutinha_vermelha.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural comestivel",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CONSUMABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [2,1,0,0],
	'inventory_slots' : 0
}
const GOSMA_SLIME_VERMELHO = {
	'nome' : 'Gosma de Slime Vermelho',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"... sem comentários é uma gosma vermelha e apenas isso.",
	'sprite' : 'red_slime_drop.png',
	'equipable' : [],
	'statistic_class' : "fluido de monstro",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,1,0,0],
	'inventory_slots' : 0
}
const GOSMA_SLIME_VERDE = {
	'nome' : 'Gosma de Slime Verde',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"... sem comentários é uma gosma verde e apenas isso.",
	'sprite' : 'green_slime_drop.png',
	'equipable' : [],
	'statistic_class' : "fluido de monstro",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,1,0,0],
	'inventory_slots' : 0
}
const TABUA = {
	'nome' : 'Tabua',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Ótimo para quem quer construir algo, um baú ou uma casa. Mas acredito que há histórias que dizem não ser um bom material para casas, um lobo poderia derruba-la com apenas um sopro.",
	'sprite' : 'tabua_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso processado",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const PROTETOR_DE_MAO = {
	'nome' : 'Protetor de Mão',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Usado para criar uma Espada de Madeira, protengendo os frágeis dedos do guerreiro.",
	'sprite' : 'protetor_mao_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "parte de item",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const GRAVETO = {
	'nome' : 'Graveto',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Um frágil graveto que pode ser usado para criar itens simples, talvez com sorte de para usar como uma varinha maǵica.",
	'sprite' : 'graveto_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "manejavel",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.WIELDABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const ESPADA_MADEIRA = {
	'nome' : 'Espada de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Uma arma branca usada para treinos, ou por crianças para brincarem... brincadeiras saudaveis.",
	'sprite' : 'espada.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "manejavel",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.WIELDABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const CABO_MADEIRA = {
	'nome' : 'Cabo de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Um cabo feito de madeira bastante utilizado para criar espadas juntamento com um Protetor de Mão. Ou sendo usado como um bom porrete, a escolha é sua.",
	'sprite' : 'cabo_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "manejavel",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.WIELDABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const MACHADO_MADEIRA = {
	'nome' : 'Machado de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Ferramenta usada para coletar mais madeira... quem foi que inventou isso? Sério? De madeira?",
	'sprite' : 'machado.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "manejavel",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.WIELDABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const CABECA_MACHADO_MADEIRA = {
	'nome' : 'Cabeça de Machado de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':" 'Lâmina' para criar o seu machado de madeira...  '¬¬",
	'sprite' : 'cabeca_machado_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "parte de item",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_MULTI_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const BLOCK_GREENSLIME = {
	'nome' : 'Bloco de Slime Verde',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':" 'Por que não fazer um bloco com a gosma do slime?",
	'sprite' : 'green_slime_block_translucid.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "bloco",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CAN_PLACE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.DONT_BREAK_ON_USE],
	'born_sstatus_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const LASCA_DE_MADEIRA = {
	'nome' : 'Lasca de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Eita lasqueira...",
	'sprite' : 'lasca_de_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural vegetal",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const GALHO_GRANDE = {
	'nome' : 'Galho grande',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Um galho grande de uma árvore.",
	'sprite' : 'galho_grande.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural vegetal",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const GALHO_FRAGIL = {
	'nome' : 'Galho Frágil',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':"Um galho frágil de uma árvore.",
	'sprite' : 'galho_fragil.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural vegetal",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const BIFE_CRU = {
	'nome' : 'Bife cru',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc': "Talvez um pouco de sal e cebola picada, um tempinha na frigideira e pronto, um bife acebolado.",
	'sprite' : 'bife_cru.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "carne de mob",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CONSUMABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [1,0,0,0],
	'inventory_slots' : 0
}
const BALDE_MADEIRA = {
	'nome' : 'Balde de Madeira',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc': "Um simples balde de madeira para conter quase todos os tipos de liquidos.",
	'sprite' : 'balde_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "utilitário container",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CONTAINER,ItemInterface.ITEM_FLAGS.CONSUMABLE_FILLED,ItemInterface.ITEM_FLAGS.FLUID_CONTAINER],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.DONT_BREAK_ON_USE],
	'born_status_max' : [10,1,0,0],
	'born_effect' : [-1,0,0,0],
	'inventory_slots' : 1
}
const LEITE = {
	'nome' : 'Leite',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc': "Leite de vaca, leite de vaca, leite de vaca!!!",
	'sprite' : '',# Definir um placeholder
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "laticinio",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CONSUMABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [1,0,0,0],
	'inventory_slots' : 0
}

const FOLHA_DE_ARVORE = {
	'nome' : 'Folha de Árvore',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc': "Uma foia amarela...",
	'sprite' : 'folha.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "recurso natural vegetal",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CONSUMABLE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [1,1,0,0],
	'inventory_slots' : 0
}
const MUDA_DE_ARVORE = {
	'nome' : 'Muda de Árvore',
	'object_type':SystemDictionary.OBJECS_TYPE.ITEM,
	'desc':" 'Vai floresta, uhuu...",
	'sprite' : 'sappling.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'statistic_class' : "bloco",
	'flags':[ItemInterface.ITEM_FLAGS.STACKABLE,ItemInterface.ITEM_FLAGS.CAN_PLACE],
	'flags_use_type' : [ItemInterface.ITEM_USE_TYPE_FLAGS.DONT_BREAK_ON_USE],
	'born_sstatus_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
