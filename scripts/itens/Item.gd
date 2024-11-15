extends Sprite2D

class_name Item

signal ranout(item)

@export var timerCollect : Timer
@export var collisionArea : Area2D

var type

var consumable : bool = false
var canContainItem : bool = false
var defensiveable : bool = false
var wieldable : bool = false
var stackable : bool = true
var collectable : bool = false

var status : Status
var inventory : Array = []
var slotEquipable : Array = []

var placeableRel : Dictionary

var storaged : int  = 1
var lastEntityCollect
var nome : String
var estatistica_class : String
var isBouncing : bool = false
var posSpawn : Vector2
var velocity_y = -300
var velocity_x = 3
var gravity_y = 800
var gravity_x = 1

static func createItem(itemType):
	var item = load("res://scenes/itens/Item.tscn").instantiate()
	item.nome = itemType.nome
	item.estatistica_class = itemType.statistic_class
	item.set_type(itemType)
	item.set_sprite(itemType.sprite)
	item.set_slot_equipable(itemType.equipable)
	item.set_wieldable(itemType.wieldable)
	item.set_placeable(RPlaceable.findRelation(itemType))
	item.set_consumable(itemType.consumable)
	item.set_inventory_slot(itemType.inventory_slots)
	item.set_defensiveable(itemType.defensiveable)
	item.initStatus()
	#item.setCanContainItem(itemType.canContainItem)
	return item

func initStatus():
	status = Status.createStatus(inventory,type)
	status.connect("lifeIsZero",itemBreak)
	
func set_wieldable(flag):
	wieldable = flag

func set_defensiveable(flag):
	defensiveable = flag

func set_inventory_slot(qtd):
	inventory.resize(qtd)

func set_placeable(r):
	if r != null:
		placeableRel = r

func set_can_contain_item(flag):
	canContainItem = flag

func set_consumable(flag):
	consumable = flag

func set_stackable(flag):
	stackable = flag

func set_collectable(flag):
	collectable = flag

func set_drops(itemdrop):
	if itemdrop != null:
		for idx in itemdrop.size():
			var drop : Item = Item.createItem(itemdrop[idx][1])
			drop.set_quantity(itemdrop[idx][0])
			for slot in inventory.size():
				if inventory[slot] == null:
					inventory[slot] = drop

func set_slot_equipable(slot):
	slotEquipable = slot

func set_sprite(sprite):
	texture = load("res://resources/itens/" + sprite)

func set_type(itemType):
	type = itemType

func canStack(item):
	return (item.type == type && stackable && item.stackable)

func isPlaceable():
	return placeableRel != null

func is_sameType(item):
	return type == item.type

func is_defensive():
	return defensiveable

func set_quantity(qtd):
	storaged = qtd
	update_name()

func accumulate(qtd = 1):
	storaged += qtd
	update_name()

func decumulate(qtd = 1):
	storaged -= qtd
	update_name()
	return Item.createItem(type)

func update_name():
	self.nome = type.nome + " ( x" +str(storaged)+ " )"

func hasAtLastQuantity(qtd:int):
	return qtd <= storaged

func isWieldable():
	return wieldable

func isStorageZero():
	return storaged == 0

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("collect"):
			if collectable:
				set_collectable(false)
				beCollected(body)

func beCollected(body):
	
	var parent = get_parent()
	if parent != null:
		parent.call_deferred("remove_child",self)
		#parent.remove_child(self)
	body.collect(self)
	lastEntityCollect = body

func hasMoreHardness(value,onWhat):
	return RUseable.findRelation(type)[onWhat] > value

func try_apply_effect(effect):
	status.applyEffect({},effect)

func useOn(statistic,target,statsEffect:Array = [0,0,0,0]):
	var effectFinal = get_effect_final(statsEffect)
	SystemBattle.apply_effect_on(statistic,effectFinal,target)
	#target.try_apply_effect(statistic,effectFinal)
	if consumable:
		itemBreak()

func itemBreak():
	decumulate()
	if self.isStorageZero():
		emit_signal("ranout",self)

func dropContent():
	set_drops(RDrop.findRelation(type))
	return inventory

func get_effect_final(statsEffect:Array):
	var effectFinal = status.get_effect()
	for sts in effectFinal.size():
		effectFinal[sts] += statsEffect[sts]
	return effectFinal

func get_placeable():
	return Placeable.createPlaceable(placeableRel)

func get_item_nome():
	return nome

func get_quantity():
	return storaged

func get_consum_status():
	return status.get_consum_status()

func get_status_effect():
	return status.get_effect()

func get_class_statistic():
	return estatistica_class

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
				set_collectable(true)
