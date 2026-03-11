extends Node

class_name ItemInterface

enum ITEM_FLAGS {WIELDABLE,CONTAINER,ITEM_CONTAINER,FLUID_CONTAINER,CONSUMABLE,DEFENSIVEABLE,CONSUMABLE_FILLED,CAN_PLACE,STACKABLE}
enum ITEM_USE_TYPE_FLAGS {BREAK_ON_SINGLE_USE,BREAK_ON_MULTI_USE,DONT_BREAK_ON_USE}


static func collect_item(item:Item,body):
	if body is CharacterBody2D:
		if body.has_method("collect"):
			if item.collectable:
				var item_data = ItemInterface.get_item_data(item)
				body.collect(item_data)
				return true
	return false

static func drop_item(item_data:Dictionary,qtd=null) -> Item :
	var item : Item = Item.create_item(item_data.type)
	item.storaged = item_data.storaged if qtd == null else qtd
	item.inventory = item_data.inventory.duplicate(true)
	item.status.set_status_from_status_data(item_data.status)
	item.lastEntityCollect = item_data.last_owner
	return item

static func get_item_data(item:Item) -> Dictionary:
	var data_info : Dictionary = {
		"type":item.type,
		"storaged":item.storaged,
		"inventory":item.inventory.duplicate(true),
		"status":StatusInterface.get_status_data(item.status.general_status,item.type),
		"last_owner": item.lastEntityCollect
	}
	item.queue_free()
	return data_info

static func create_data_from_type(type,last_owner):
	var data_info : Dictionary = {
		"type":type,
		"storaged":1,
		"inventory":[],
		"status": StatusInterface.create_data_from_type(type),
		"last_owner": last_owner
	}
	return data_info

static func can_stack_item(item_type,item_to_stack_type):
	return item_to_stack_type == item_type && item_type.flags.has(ItemInterface.ITEM_FLAGS.STACKABLE)

static func has_one_slot(item_type):
	return item_type.inventory_slots == 1 if ItemInterface.is_container(item_type) else false

static func has_at_last_quantity(item,qtd:int):
	return qtd <= item.storaged

static func has_more_hardness(item_type,value,onWhat):
	return RUseable.findRelation(item_type)[onWhat] > value

static func has_flag(item_type,flag:ITEM_FLAGS):
	return item_type.flags.has(flag)

static func has_use_type_flag(item_type,flag:ITEM_USE_TYPE_FLAGS):
	return item_type.flags_use_type.has(flag)

static func is_empty(item,slot=-1):
	if slot == -1:
		for slt in item.inventory:
			if slt != null:
				return false
		return true
	else:
		if item.inventory.size() < 1:
			return true
		return item.inventory[slot] == null

static func is_sameType(item_a,item_b):
	return item_a.type == item_b.type

static func is_storage_zero(item):
	return item.storaged == 0

static func is_placeable(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.CAN_PLACE)

static func is_defensive(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.DEFENSIVEABLE)

static func is_wieldable(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.WIELDABLE)

static func is_consumable(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.CONSUMABLE)

static func is_container(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.CONTAINER)

static func is_fluid_container(item_type):
	return ItemInterface.has_flag(item_type,ITEM_FLAGS.FLUID_CONTAINER)

static func is_break_on_single_use(item_type):
	return ItemInterface.has_use_type_flag(item_type,ITEM_USE_TYPE_FLAGS.BREAK_ON_SINGLE_USE)

############

static func set_inventory_slot(item,qtd):
	item.inventory.resize(qtd)


static func set_slot_equipable(item,slot):
	item.slotEquipable = slot

static func set_quantity(item,qtd):
	item.storaged = qtd

static func get_effect_final(item_status,statsEffect:Array):
	var effectFinal = StatusInterface.get_effect(StatusInterface.get_general_status(item_status.status if item_status is not Status else item_status))
	for sts in effectFinal.size():
		effectFinal[sts] += statsEffect[sts]
	return effectFinal

static func get_placeable(item_type):
	return Placeable.create_placeable(RPlaceable.findRelation(item_type))

static func get_item_nome(item):
	var item_qtd = " ( x" +str(ItemInterface.get_quantity(item))+ " )"
	var item_nome = ItemInterface.get_item_type_nome(item.type)
	var content_nome = ""
	if item.inventory.size() == 1 and item.inventory[0] != null:
		var content_item = ItemInterface.get_item_in_inventory(item,0)
		content_nome = " [ " + ItemInterface.get_item_type_nome(content_item[1]).get_slice(' (',0) + " ]"
	return (item_nome + content_nome + item_qtd)

static func get_item_type_nome(item_type):
	return item_type.nome

static func get_item_desc(item_type):
	return item_type.desc

static func get_quantity(item):
	if item is Dictionary:
		return item.storaged
	return item.storaged

static func get_consum_status(item_status):
	return StatusInterface.get_consum_status(StatusInterface.get_general_status(item_status.status))#status.general_status

static func get_status_effect(item_status):
	return StatusInterface.get_effect(StatusInterface.get_general_status(item_status.status))#status.general_status

static func get_class_statistic(item):
	return item.type.statistic_class

static func get_slot_equipable(item):
	return item.type.equipable

static func get_drop(item_type):
	return RDrop.findRelation(item_type).drop_p.duplicate(true)

static func get_texture(item_type):
	return load("res://resources/itens/" + item_type.sprite)

static func get_item_in_inventory(item,idx):
	return  item.inventory[idx]

static func use_on(statistic,item,target,statsEffect:Array = [0,0,0,0]):
	var effectFinal = ItemInterface.get_effect_final(item.status,statsEffect)
	SystemBattle.apply_effect_on(statistic,effectFinal,target)
	#target.try_apply_effect(statistic,effectFinal)
	if item.consumable:
		item.itemBreak()

static func accumulate(item_data,qtd = 1):
	item_data.storaged += qtd

static func decumulate(item_data,qtd = 1):
	item_data.storaged -= qtd

static func add_content_to_container(container,content):
	container.inventory.append(content)

static func remove_content_from_container(container,slot:int = 0):
	container.inventory.remove_at(slot)
