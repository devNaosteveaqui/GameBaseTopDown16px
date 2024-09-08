extends Node

class_name Itens

const TRONCO = {
	'nome' : 'Tronco de Árvore',
	'desc':"Bom, todo item de madeira precisa vir de algum lugar, por exemplo... um tronco de árvore talvez?",
	'sprite' : 'madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'born_status' : [10,0,0,0],
	'born_status_max' : [10,0,0,0],
	'born_effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const PEDRA = {
	'nome' : 'Pedra',
	'desc':"Já viu uma Pedra?",
	'sprite' : 'pedra.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const FRUTA_VERMELHA = {
	'nome' : 'Fruta Vermelha',
	'desc':"Uma fruta estranha, não é morango e nem maçã mas é vermelha e estranhamente restaura sua vida?",
	'sprite' : 'frutinha_vermelha.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : true,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [2,1,0,0],
	'inventory_slots' : 0
}
const GOSMA_SLIME_VERMELHO = {
	'nome' : 'Gosma de Slime Vermelho',
	'desc':"... sem comentários é uma gosma vermelha e apenas isso.",
	'sprite' : 'red_slime_drop.png',
	'equipable' : [],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const GOSMA_SLIME_VERDE = {
	'nome' : 'Gosma de Slime Verde',
	'desc':"... sem comentários é uma gosma verde e apenas isso.",
	'sprite' : 'green_slime_drop.png',
	'equipable' : [],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const TABUA = {
	'nome' : 'Tabua',
	'desc':"Ótimo para quem quer construir algo, um baú ou uma casa. Mas acredito que há histórias que dizem não ser um bom material para casas, um lobo poderia derruba-la com apenas um sopro.",
	'sprite' : 'tabua_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const PROTETOR_DE_MAO = {
	'nome' : 'Protetor de Mão',
	'desc':"Usado para criar uma Espada de Madeira, protengendo os frágeis dedos do guerreiro.",
	'sprite' : 'protetor_mao_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const GRAVETO = {
	'nome' : 'Graveto',
	'desc':"Um frágil graveto que pode ser usado para criar itens simples, talvez com sorte de para usar como uma varinha maǵica.",
	'sprite' : 'graveto_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const ESPADA_MADEIRA = {
	'nome' : 'Espada de Madeira',
	'desc':"Uma arma branca usada para treinos, ou por crianças para brincarem... brincadeiras saudaveis.",
	'sprite' : 'espada.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const CABO_MADEIRA = {
	'nome' : 'Cabo de Madeira',
	'desc':"Um cabo feito de madeira bastante utilizado para criar espadas juntamento com um Protetor de Mão. Ou sendo usado como um bom porrete, a escolha é sua.",
	'sprite' : 'cabo_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const MACHADO_MADEIRA = {
	'nome' : 'Machado de Madeira',
	'desc':"Ferramenta usada para coletar mais madeira... quem foi que inventou isso? Sério? De madeira?",
	'sprite' : 'machado.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [-1,0,0,0],
	'inventory_slots' : 0
}
const CABECA_MACHADO_MADEIRA = {
	'nome' : 'Cabeça de Machado de Madeira',
	'desc':" 'Lâmina' para criar o seu machado de madeira...  '¬¬",
	'sprite' : 'cabeca_machado_madeira.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
const BLOCK_GREENSLIME = {
	'nome' : 'Bloco de Slime Verde',
	'desc':" 'Por que não fazer um bloco com a gosma do slime?",
	'sprite' : 'green_slime_block_translucid.png',
	'equipable' : [Inventory.HAND_L,Inventory.HAND_R],
	'consumable' : false,
	'canContainItem' : false,
	'defensiveable':false,
	'status' : [10,0,0,0],
	'status_max' : [10,0,0,0],
	'effect' : [0,0,0,0],
	'inventory_slots' : 0
}
