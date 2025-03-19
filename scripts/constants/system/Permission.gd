extends Node

# Nessa classe qualquer tipo de permissão é adicionado ao ser instanciado ou quando um novo tipo de
#permissão for nescessária ao jogo como o jogador poder abrir uma porta especifica ou movimentos que
#só podem ser utilizados caso tenha as condições nescessárias. O valor das permissões podem ser
#alteradas conforme as condições são atingidas.

#Tudo que precisa de permissão precisa ser definido no próprio código da classe,

var has_permissions_at : Array[String]
var permissions_to_give : Dictionary

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	pass

func add_permission(new_permission:String) -> void:
	has_permissions_at.append(new_permission)

func add_permission_to_give(permission:String) -> void:
	permissions_to_give[permission] = {'name':permission}

func has_permission(permission:String) -> bool:
	return has_permissions_at.has(permission)

func remove_permission(permission:String) -> void:
	var p = has_permissions_at.find(permission)
	if p != -1:
		has_permissions_at.remove_at(p)

func give_permission_at():
	pass
