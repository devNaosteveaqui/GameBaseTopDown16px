extends Sprite2D

class_name Item

var storaged : int
var type
var stackable : bool = true

static func createItem(itemType):
	var item = load("res://REMAKE/scenes/itens/Item.tscn").instantiate()
	item.setSprite(itemType.sprite)
	item.setType(itemType)
	return item

func setSprite(sprite):
	texture = load("res://REMAKE/resources/itens/" + sprite)

func setType(itemType):
	type = itemType

func is_sameType(item):
	return type == item.type

func accumulate(qtd = 1):
	storaged += qtd

func decumulate(qtd = 1):
	storaged -= qtd
	return qtd == 0
