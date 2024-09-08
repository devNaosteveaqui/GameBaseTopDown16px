extends Sprite2D

class_name Item

signal ranout(item)

@export var timerCollect : Timer
@export var collisionArea : Area2D

var type

var consumable : bool = false
var canContainItem : bool = false
var defensiveable : bool = false

var stackable : bool = true
var collectable : bool = false

var status : Status
var inventory : Array = []
var slotEquipable : Array = []

var placeableRel : Dictionary

var storaged : int  = 1
var lastEntityCollect
var nome : String

var isBouncing : bool = false
var posSpawn : Vector2
var velocity_y = -300
var velocity_x = 3
var gravity_y = 800
var gravity_x = 1

static func createItem(itemType):
	var item = load("res://scenes/itens/Item.tscn").instantiate()
	item.nome = itemType.nome
	item.setType(itemType)
	item.setSprite(itemType.sprite)
	item.setSlotEquipable(itemType.equipable)
	
	item.setPlaceable(RPlaceable.findRelation(itemType))
	item.setConsumable(itemType.consumable)
	item.setInventorySlot(itemType.inventory_slots)
	item.setDefensiveable(itemType.defensiveable)
	item.initStatus()
	#item.setCanContainItem(itemType.canContainItem)
	return item

func initStatus():
	status = Status.createStatus(inventory,type)
	status.connect("lifeIsZero",itemBreak)
	

func setDefensiveable(flag):
	defensiveable = flag

func setInventorySlot(qtd):
	inventory.resize(qtd)

func setPlaceable(r):
	if r != null:
		placeableRel = r

func setCanContainItem(flag):
	canContainItem = flag

func setConsumable(flag):
	consumable = flag

func setStackable(flag):
	stackable = flag

func setCollectable(flag):
	collectable = flag

func setDrops(itemdrop):
	if itemdrop != null:
		for idx in itemdrop.size():
			var drop : Item = Item.createItem(itemdrop[idx][1])
			drop.setQuantity(itemdrop[idx][0])
			for slot in inventory.size():
				if inventory[slot] == null:
					inventory[slot] = drop

func setSlotEquipable(slot):
	slotEquipable = slot

func setSprite(sprite):
	texture = load("res://resources/itens/" + sprite)

func setType(itemType):
	type = itemType

func canStack(item):
	return (item.type == type && stackable && item.stackable)

func isPlaceable():
	return placeableRel != null

func is_sameType(item):
	return type == item.type

func is_defensive():
	return defensiveable

func setQuantity(qtd):
	storaged = qtd
	updateName()

func accumulate(qtd = 1):
	storaged += qtd
	updateName()

func decumulate(qtd = 1):
	storaged -= qtd
	updateName()
	return Item.createItem(type)

func updateName():
	self.nome = type.nome + " ( x" +str(storaged)+ " )"

func hasAtLastQuantity(qtd:int):
	return qtd <= storaged

func isStorageZero():
	return storaged == 0

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("collect"):
			if collectable:
				collectable = false
				beCollected(body)

func beCollected(body):
	
	var parent = get_parent()
	if parent != null:
		parent.remove_child(self)
	body.collect(self)
	lastEntityCollect = body

func hasMoreHardness(value,onWhat):
	return RUseable.findRelation(type)[onWhat] > value

func tryApplyEffect(effect):
	status.applyEffect(effect)

func useOn(target,statsEffect:Array = [0,0,0,0]):
	var effectFinal = status.getEffect()
	for sts in effectFinal.size():
		effectFinal[sts] += statsEffect[sts]
	target.tryApplyEffect(effectFinal)
	
	if consumable:
		itemBreak()

func itemBreak():
	decumulate()
	if self.isStorageZero():
		emit_signal("ranout",self)

func dropContent():
	setDrops(RDrop.findRelation(type))
	return inventory


func getPlaceable():
	return Placeable.createPlaceable(placeableRel)

func getItemNome():
	return nome

func getQuantity():
	return storaged

func getConsumStatus():
	return status.getConsumStatus()



func dropOnGround(posSpawn):
	self.posSpawn = posSpawn
	self.position = posSpawn
	velocity_x = velocity_x*(randi()%3 - 1)

func _on_tree_entered():
	isBouncing = true
	collectable = false

func _on_tree_exited():
	isBouncing = false

func _physics_process(delta):
	if isBouncing:
		position.y += velocity_y*delta
		position.x += velocity_x*delta
		
		velocity_y += gravity_y*delta
		velocity_x += gravity_x*delta
		
		if abs(posSpawn.y - position.y) < 4:
			velocity_y = -velocity_y*0.6
			if abs(velocity_y) < 50:
				isBouncing = false
				collectable = true
