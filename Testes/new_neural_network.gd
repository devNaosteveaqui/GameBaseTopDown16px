extends Node

class_name NewNeuralNetwork

#Constructor
var w_hidden : PackedFloat64Array= []
var w_output : PackedFloat64Array = []

var bias_hidden : PackedFloat64Array = []
var bias_outbput : PackedFloat64Array = []

var hidden_response : PackedFloat64Array = []
var output_response : PackedFloat64Array = []

var input_n : int # Nós de entrada
var hidden_n : int # Nós por camada
var hidden_layer_n : int
var output_n : int # Nós de saida

# Função sigmóide
func _sigmoid(x: float) -> float:
	return 1.0 / (1.0 + exp(-x))

# Derivada da sigmóide
func _sigmoid_derivative(y: float) -> float:
	return y * (1.0 - y)

func foward_hidden_node(input:float,input_id:int, hidden_id:int):
	# Line : Linha da matriz
	# Colum : Coluna da Matriz
	# O array será organizado da seguinte forma, cada layer da rede é uma coluna e seus valores serão 
	#posicionados sequencialmente ou seja, a primeira camada ocupará as primeiras posições do array, a
	#segunda camada, as possições seguintes e por ai vai.
	return input*w_hidden[input_id + (hidden_id*(input_n))]

func foward(input:PackedFloat64Array):
	hidden_response = []
	for j in range(bias_hidden.size()): # Layer in entra nessa camada
		var soma = bias_hidden[j]
		for i in range(input.size()): # Layer Out sai dessa camada
			soma += foward_hidden_node(input[i],i,j)
		hidden_response.append(_sigmoid(soma))

	output_response = []
	for k in range(bias_outbput.size()):
		var soma = bias_outbput[k]
		for j in range(hidden_response.size()):
			soma += hidden_response[j] * w_output[j][k]
		output_response.append(_sigmoid(soma))

	return output_response
