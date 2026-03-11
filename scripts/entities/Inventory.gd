extends Node

class_name Inventory

signal inventoryUpdated
signal item_storaged(statistics)
const COSTAS_1 : int = 0
const HEAD : int = 1
const COSTAS_2 : int = 2
const HAND_R : int = 3
const TORSO : int = 4
const HAND_L : int = 5
const ACESSORIO_1 : int = 6
const PERNAS : int = 7
const ACESSORIO_2 : int = 8
const ACESSORIO_3 : int = 9
const PES : int = 10
const ACESSORIO_4 : int = 11

const EMPTY_SLOT_PLACEHOLDER = {
	Inventory.HEAD : GameConfig.PATH_RESOURCE_INTERFACE + "head_slot_symbol.png",
	Inventory.TORSO : GameConfig.PATH_RESOURCE_INTERFACE + "chest_slot_symbol.png",
	Inventory.PERNAS : GameConfig.PATH_RESOURCE_INTERFACE + "leg_slot_symbol.png",
	Inventory.PES : GameConfig.PATH_RESOURCE_INTERFACE + "foot_slot_symbol.png",
	Inventory.HAND_L : GameConfig.PATH_RESOURCE_INTERFACE + "hold_slot_symbol.png",
	Inventory.HAND_R : GameConfig.PATH_RESOURCE_INTERFACE + "hold_slot_symbol.png",
	Inventory.COSTAS_1 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png",
	Inventory.COSTAS_2 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png",
	Inventory.ACESSORIO_1 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png",
	Inventory.ACESSORIO_2 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png",
	Inventory.ACESSORIO_3 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png",
	Inventory.ACESSORIO_4 : GameConfig.PATH_RESOURCE_INTERFACE + "finger_slot_symbol.png"
}

var inventory : Array = []
var equiped : Array = []

func create_inventory():
	inventory.resize(20)
	equiped.resize(12)

func store_item(item,typeStore):
	var firstSlotNull = -1
	for slot in inventory.size():
		if not is_inventory_slot_empty(slot):
			if ItemInterface.can_stack_item(inventory[slot].type,item.type):
				ItemInterface.accumulate(inventory[slot],ItemInterface.get_quantity(item))
				#inventory[slot].connect("ranout",itemConsumed)
				emit_signal("inventoryUpdated")
				emit_signal("item_storaged",Estatisticas.createItemMetric(typeStore,item))
				return true
		else:
			if firstSlotNull == -1:
				firstSlotNull = slot
	if firstSlotNull == -1:
		return false
	else:
		set_inventory_slot(firstSlotNull,item)
		emit_signal("inventoryUpdated")
		emit_signal("item_storaged",Estatisticas.createItemMetric(typeStore,item))
		return true

func set_equiped_slot(slot,value):
	equiped[slot] = value

func set_inventory_slot(slot,value):
	inventory[slot] = value

func unstore_item(storaged_idx):
	if not is_inventory_slot_empty(storaged_idx):
		ItemInterface.decumulate(inventory[storaged_idx])
		var item = ItemInterface.drop_item(inventory[storaged_idx],1)
		if ItemInterface.is_storage_zero(inventory[storaged_idx]):
			set_inventory_slot(storaged_idx,null)
			#item.disconnect("ranout",itemConsumed)
		emit_signal("inventoryUpdated")
		return item
	return null

func consumItem(itemType,qtd):
	for idx in inventory.size():
		if not is_inventory_slot_empty(idx):
			if is_type_item_inventory(idx,itemType):
				ItemInterface.decumulate(inventory[idx],qtd)
				if ItemInterface.is_storage_zero(inventory[idx]):
					#inventory[idx] = null
					set_inventory_slot(idx,null)
				emit_signal("inventoryUpdated")

func itemConsumed(item):
	var dropAtConsum = item.dropContent()
	if inventory.has(item):
		set_inventory_slot(inventory.find(item),null)
	elif equiped.has(item):
		set_equiped_slot(equiped.find(item),null)
	for i in dropAtConsum:
		store_item(i,-2)#"ConsumDrop"
	emit_signal("inventoryUpdated")

func get_quantity_this_item(itemType):
	for idx in inventory.size():
		if not is_inventory_slot_empty(idx):
			if is_type_item_inventory(idx,itemType):
				return ItemInterface.get_quantity(inventory[idx])
	return 0

func has_this_item_quantity(itemType,qtd:int):
	for idx in inventory.size():
		if not is_inventory_slot_empty(idx):
			if is_type_item_inventory(idx,itemType):
				return ItemInterface.has_at_last_quantity(inventory[idx],qtd)
	return false

func has_principal_item():
	var handSlot = HAND_L if is_equip_slot_empty(HAND_R) else HAND_R
	return not is_equip_slot_empty(handSlot)

func get_useable_equiped_slot_idx():
	var slot = HAND_L
	if not is_equip_slot_empty(slot):
		if ItemInterface.is_consumable(equiped[slot].type) or ItemInterface.is_container(equiped[slot].type):
			return slot
	slot = HAND_R
	if not is_equip_slot_empty(slot):
		if ItemInterface.is_consumable(equiped[slot].type) or ItemInterface.is_container(equiped[slot].type):
			return slot
	return -1

func get_principal_item_name():
	if has_principal_item():
		return get_principal_item().type.nome
	return null

func equipItem(storaged_idx):
	var slotEquipable = -1
	if not is_inventory_slot_empty(storaged_idx):
		slotEquipable = searchEquipableSlot(inventory[storaged_idx].slotEquipable,inventory[storaged_idx])
	if slotEquipable > -1:
		var item = unstore_item(storaged_idx)
		if item != null:
			if not is_equip_slot_empty(slotEquipable):
				equiped[slotEquipable].accumulate()
			else:
				#equiped[slotEquipable] = item
				set_equiped_slot(slotEquipable,item)
				equiped[slotEquipable].connect("ranout",itemConsumed)
			emit_signal("inventoryUpdated")
			return true
	return false

func equipItemAt(storaged_idx,slot_idx):
	var slotEquipable = -1
	if not is_inventory_slot_empty(storaged_idx):
		slotEquipable = isEquipableAtSlot(ItemInterface.get_slot_equipable(inventory[storaged_idx]),inventory[storaged_idx],slot_idx)
	if slotEquipable :
		var item = unstore_item(storaged_idx)
		if item != null:
			if not is_equip_slot_empty(slot_idx):
				equiped[slot_idx].accumulate()
			else:
				#equiped[slotEquipable] = item
				set_equiped_slot(slot_idx,item)
				equiped[slot_idx].connect("ranout",itemConsumed)
			emit_signal("inventoryUpdated")
			return true
	return false

func searchEquipableSlot(itemSlotsAble,item):
	if itemSlotsAble.size() > 0:
		for slot in itemSlotsAble:
			if is_equip_slot_empty(slot):
				return slot
			elif ItemInterface.can_stack_item(equiped[slot].type,item.type):
				return slot
	return -1

func isEquipableAtSlot(itemSlotsAble,item,slotTarget):
	if (itemSlotsAble.has(slotTarget) and itemSlotsAble.size() > 0):
		for slot in itemSlotsAble:
			return (is_equip_slot_empty(slotTarget) or ItemInterface.can_stack_item(equiped[slotTarget].type,item.type))
	return false

func is_equip_slot_empty(idx):
	return equiped[idx] == null

func is_inventory_slot_empty(idx):
	return inventory[idx] == null

func is_type_item_inventory(idx,type):
	return inventory[idx].type == type

func unequipItem(idx):
	if not is_equip_slot_empty(idx):
		if store_item(equiped[idx],-1):#"unequip"
			set_equiped_slot(idx,null)
			emit_signal("inventoryUpdated")

func dropItemStoraged(storaged_idx):
	var item = unstore_item(storaged_idx)
	if item != null:
		get_parent().drop(item)

func dropItemEquiped(storaged_idx):
	if not is_equip_slot_empty(storaged_idx):
		var item = equiped[storaged_idx]
		item.disconnect("ranout",itemConsumed)
		get_parent().drop(item)
		set_equiped_slot(storaged_idx,null)

func get_principal_item():
	var handSlot = HAND_R if not is_equip_slot_empty(HAND_R) else HAND_L
	return equiped[handSlot]

func damageArmor(value,idx):
	var armor = get_armor_defense()
	armor[idx].try_apply_effect(value)

func get_hardeness_amor_pieces():
	var armor = get_armor_defense()
	var hardness = []
	for a in armor:
		hardness.append(RUseable.findRelation(a.type).by_item)
	return hardness

func getItemPlaceable():
	var item
	var handSlot = HAND_R if not is_equip_slot_empty(HAND_R) else HAND_L
	if not is_equip_slot_empty(handSlot):
		if ItemInterface.is_placeable(equiped[handSlot].type):
			ItemInterface.decumulate(equiped[handSlot])
			var item_type = equiped[handSlot].type
			if ItemInterface.is_storage_zero(equiped[handSlot]):
				#equiped[handSlot] = null
				set_equiped_slot(handSlot,null)
			emit_signal("inventoryUpdated")
			item = ItemInterface.get_placeable(item_type)
			item.position = get_parent().get_position_on_eye()
			return item
	return null

func use_item_usable(slotIdx,onTarget):
	var item : Item = equiped[slotIdx]
	var func_ref : RUseableFunc.FUNCTIONS = RUseableFunc.findRelation(item.type)
	if func_ref == RUseableFunc.FUNCTIONS.USE_LOQUID_CONTAINER:
		UseableInterface.use_liquid_container(item,onTarget)
	elif func_ref == RUseableFunc.FUNCTIONS.USE_CONSUMABLE:
		UseableInterface.use_consumable(item,onTarget)
	if ItemInterface.is_storage_zero(item):
		set_equiped_slot(slotIdx,null)

func get_armor_defense_value(idx,status):
	if equiped[idx].has_method("get_defense"):
		var value = equiped[idx].get_defense() #PROBLEM TO RESOLVE
		return value[status]
	return 0

func get_armor_defense():
	var equipedDef = []
	for e in equiped:
		if e != null:
			#Precisa verificar caso o item não seja uma vestimenta ou tenha a propriedade
			if ItemInterface.is_defensive(e.type):
				equipedDef.append(e)
	return equipedDef

func get_item_consumable_status():
	var handSlot = HAND_R
	if is_equip_slot_empty(handSlot):
		handSlot = HAND_L
	if not is_equip_slot_empty(handSlot):
		return ItemInterface.get_consum_status(equiped[handSlot])
	return [0,0,0,0]

func get_item_inventory_info(index):
	var item = inventory[index]
	var info : String
	if item != null:
		info = "Nome : " + ItemInterface.get_item_nome(item) + "\n"
		info += ItemInterface.get_item_desc(item.type)
	return info

func get_item_equiped_info(index):
	var item = equiped[index]
	var info : String
	if not is_equip_slot_empty(index):
		info = "Nome : " + ItemInterface.get_item_nome(item) + "\n"
		info += ItemInterface.get_item_desc(item.type)
	return info

func isWieldableItemEquiped():
	var hand_l_has = not is_equip_slot_empty(HAND_L) and ItemInterface.is_wieldable(equiped[HAND_L].type)
	var hand_r_has = not is_equip_slot_empty(HAND_R) and ItemInterface.is_wieldable(equiped[HAND_R].type)
	return  hand_l_has or hand_r_has

func isHandsFree():
	var hand_l_has = is_equip_slot_empty(HAND_L)
	var hand_r_has = is_equip_slot_empty(HAND_R)
	return  hand_l_has or hand_r_has
