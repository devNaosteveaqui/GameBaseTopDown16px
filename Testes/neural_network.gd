extends Node

class_name NeuralNetwork

# Função sigmóide
func _sigmoid(x: float) -> float:
	return 1.0 / (1.0 + exp(-x))

# Derivada da sigmóide
func _sigmoid_derivative(y: float) -> float:
	return y * (1.0 - y)

# Construtor
var weights_input_hidden = []
var weights_hidden_output = []
var bias_hidden = []
var bias_output = []

var hidden = []
var output = []

func _init(n_inputs: int, n_hidden: int, n_outputs: int):
	# Pesos entrada -> oculta
	weights_input_hidden = []
	for i in range(n_inputs):# Layer Out sai dessa camada
		var row = []
		for j in range(n_hidden): # Layer in entra nessa camada
			row.append(randf_range(-1.0, 1.0))
		weights_input_hidden.append(row)

	# Pesos oculta -> saída
	weights_hidden_output = []
	for j in range(n_hidden):
		var row = []
		for k in range(n_outputs):
			row.append(randf_range(-1.0, 1.0))
		weights_hidden_output.append(row)

	# Bias
	bias_hidden = []
	for j in range(n_hidden):
		bias_hidden.append(randf_range(-1.0, 1.0))

	bias_output = []
	for k in range(n_outputs):
		bias_output.append(randf_range(-1.0, 1.0))


# Forward pass
func forward(inputs: Array) -> Array:
	hidden = []
	for j in range(bias_hidden.size()): # Layer in entra nessa camada
		var soma = bias_hidden[j]
		for i in range(inputs.size()): # Layer Out sai dessa camada
			soma += inputs[i] * weights_input_hidden[i][j]
		hidden.append(_sigmoid(soma))

	output = []
	for k in range(bias_output.size()):
		var soma = bias_output[k]
		for j in range(hidden.size()):
			soma += hidden[j] * weights_hidden_output[j][k]
		output.append(_sigmoid(soma))

	return output


# Treinamento com backpropagation
func train(inputs: Array, targets: Array, learning_rate: float = 0.1) -> void:
	var outputs = forward(inputs)

	# Erro da saída
	var output_errors = []
	for k in range(targets.size()):
		output_errors.append(targets[k] - outputs[k])

	# Gradiente da saída
	var output_deltas = []
	for k in range(outputs.size()):
		output_deltas.append(output_errors[k] * _sigmoid_derivative(outputs[k]))

	# Ajusta pesos oculta -> saída
	for j in range(hidden.size()):
		for k in range(outputs.size()):
			weights_hidden_output[j][k] += learning_rate * output_deltas[k] * hidden[j]

	# Ajusta bias saída
	for k in range(bias_output.size()):
		bias_output[k] += learning_rate * output_deltas[k]

	# Erro da camada oculta
	var hidden_errors = []
	for j in range(hidden.size()):
		var erro = 0.0
		for k in range(outputs.size()):
			erro += output_deltas[k] * weights_hidden_output[j][k]
		hidden_errors.append(erro)

	# Gradiente da oculta
	var hidden_deltas = []
	for j in range(hidden.size()):
		hidden_deltas.append(hidden_errors[j] * _sigmoid_derivative(hidden[j]))

	# Ajusta pesos entrada -> oculta
	for i in range(inputs.size()):
		for j in range(hidden.size()):
			weights_input_hidden[i][j] += learning_rate * hidden_deltas[j] * inputs[i]

	# Ajusta bias oculta
	for j in range(bias_hidden.size()):
		bias_hidden[j] += learning_rate * hidden_deltas[j]
