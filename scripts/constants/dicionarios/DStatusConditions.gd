extends Node

class_name StatusConditions

const REGEN_MAGICA = {
	'nome' : 'Regeneração Magica',
	'desc':"Efeito de restaurar a sua energia mágica.",
	'sprite' : '',
	'born_effect' : [0,0,1,0]
}
const FADIGA_MAGICA = {
	'nome' : 'Fadiga Mágica',
	'desc':"Efeito que é desencadeado quando se usa mais energia mágica do que o corpo possui.",
	'sprite' : '',
	'born_effect' : [-1,0,0,0]
}
const SANGRAMENTO_MAGICO = {
	'nome' : 'Sangramento Mágic',
	'desc':"Energia mágica está se esvaindo sem controle.",
	'sprite' : '',
	'born_effect' : [0,0,-1,0]
}
