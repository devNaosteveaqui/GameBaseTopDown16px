extends Node

class_name NeuralNode

var weigth : PackedFloat64Array
var bias : float

func foward(input:float,input_id:int) -> float:
	return input*weigth[input_id]

func get_bias() -> float:
	return bias
