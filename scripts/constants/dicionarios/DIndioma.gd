extends Node

class_name Indiomas
#Indioma - comunicação falada no pais
#Dialeto - mesmo indioma mas por questões regionais/históricas possui uma difenreça
#Linguagem - não se limita ao que é falado mas sim a forma como se comunica
#Sotaque - um indioma com detalhes de outro povo
enum LINGUAGEM {VISUAL,SENSITIVA,AUDITIVA,QUIMICA,TELEPATIA}

const FALA = {
	'nome' : "Linguagem falada",
	'desc' : "Linguagem que se utiliza a habilidade de falar.",
	'type' : LINGUAGEM.AUDITIVA
}
const OPTICO = {
	'nome' : "Linguagem óptica",
	'desc' : "Linguagem que utiliza emissão de luz para se comunicar.",
	'type' : LINGUAGEM.VISUAL
}
const TRANSLUMINACAO = {
	'nome' : "Linguagem transluminação",
	'desc' : "Linguagem que utiliza da mudança de opacidade para se comunicar.",
	'type' : LINGUAGEM.VISUAL
}
const TERMICA = {
	'nome' : "Linguagem térmica",
	'desc' : "Linguagem que utiliza emissão de calor para se comunicar.",
	'type' : LINGUAGEM.SENSITIVA
}
const GEMIDO = {
	'nome' : "Linguagem por gemidos",
	'desc' : "Linguagem que utiliza emissão de som através de gemidos.",
	'type' : LINGUAGEM.AUDITIVA
}
const LUZMORSE = {
	'nome' : "Luzmorse",
	'desc' : "Indioma que consiste em mudar a opacidade em sequencias semelhantes ao código morse.",
	'Linguagem' : LINGUAGEM.VISUAL, #Visual, Sensitiva, Auditiva, Quimica, Telepatia
	'Comunicacao' : TRANSLUMINACAO #
}
const HUMAN_PTBR = {
	'nome' : "Português Brasileiro Humano",
	'desc' : "Indioma português do Brasil, que humanos utilizam para se comunicar usando da fala.",
	'Linguagem' : LINGUAGEM.AUDITIVA, #Visual, Sensitiva, Auditiva, Quimica, Telepatia
	'Comunicacao' : FALA #
}
const MUGIDO = {
	'nome' : "Mugido",
	'desc' : "Indioma de seres vivos que possuem linhagens próximas de animais bovinos.",
	'Linguagem' : LINGUAGEM.AUDITIVA, #Visual, Sensitiva, Auditiva, Quimica, Telepatia
	'Comunicacao' : GEMIDO #
}
const indiomas_lista = {
	HUMAN_PTBR.nome : HUMAN_PTBR,
	LUZMORSE.nome : LUZMORSE,
	MUGIDO.nome : MUGIDO
}
# Niveis de compreenção
# Cosnegue entender algumas palavra
# Consegue transmitir apenas algumas palavras
# Consegue entender algumas frases
# Consegue transmitir apenas algumas frases mas não um texto por completo
# Consegue entender o indioma
# Consegue transmitir a mensagem pelo indioma porém com muito sotaque
# Consegue transmitir a mensagem pelo indioma porém com pouco sotaque
# Consegue transmitir a mensagem pelo indioma de forma nativa
