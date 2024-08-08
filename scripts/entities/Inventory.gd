extends Node

var inventory : Array = []

func _ready():
	inventory.resize(16)
	
func store_item(item):
	if item.stackable :
		for id in inventory.size():
			if inventory[id].is_sameType(item):
				inventory[id].accumulate()
				return false
	for id in inventory.size():
		if inventory[id] == null:
			inventory[id] = item
			return false
	return true

func unstore_item(item):
	for id in inventory.size():
		if inventory[id].is_sameType(item):
			if item.stackable :
				if inventory[id].decumulate():
					inventory[id] = null
			else:
				inventory[id] = null
			return false
	return true
