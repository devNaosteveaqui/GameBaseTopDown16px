extends Node

func _ready():
	var nn = NeuralNetwork.new(2, 4, 1)  # 2 entradas, 4 neurônios escondidos, 1 saída

	var treinos = [
		[[0, 0], [0]],
		[[0, 1], [1]],
		[[1, 0], [1]],
		[[1, 1], [0]]
	]

	# Treinar
	for epoch in range(5000):
		var par = treinos[randi() % treinos.size()]
		nn.train(par[0], par[1], 0.5)

	# Testar XOR
	print("0 XOR 0 = ", nn.forward([0, 0]))
	print("0 XOR 1 = ", nn.forward([0, 1]))
	print("1 XOR 0 = ", nn.forward([1, 0]))
	print("1 XOR 1 = ", nn.forward([1, 1]))
