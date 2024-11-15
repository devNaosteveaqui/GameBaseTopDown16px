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

var inventory : Array = []
var equiped : Array = []

func createInventory():
	inventory.resize(20)
	equiped.resize(12)

func store_item(item,typeStore):
	var firstSlotNull = -1
	for slot in inventory.size():
		if inventory[slot] != null:
			if inventory[slot].canStack(item):
				inventory[slot].accumulate(item.get_quantity())
				inventory[slot].connect("ranout",consumItem)
				emit_signal("inventoryUpdated")
				emit_signal("item_storaged",{'metric':typeStore,'metric_class':Estatisticas.ESTATISTICAS_CLASS.ITENS,'cause':item.get_class_statistic(),'value':item.get_quantity(),'agent':item.get_item_nome()})
				return true
		else:
			if firstSlotNull == -1:
				firstSlotNull = slot
	if firstSlotNull == -1:
		return false
	else:
		#inventory[firstSlotNull] = item
		set_inventory_slot(firstSlotNull,item)
		emit_signal("inventoryUpdated")
		emit_signal("item_storaged",{'metric':typeStore,'metric_class':Estatisticas.ESTATISTICAS_CLASS.ITENS,'cause':item.get_class_statistic(),'value':item.get_quantity(),'agent':item.get_item_nome()})
		return true

func set_equiped_slot(slot,value):
	equiped[slot] = value

func set_inventory_slot(slot,value):
	inventory[slot] = value

func unstore_item(storaged_idx):
	if inventory[storaged_idx] != null:
		var item = inventory[storaged_idx].decumulate()
		if inventory[storaged_idx].isStorageZero():
			set_inventory_slot(storaged_idx,null)
			#inventory[storaged_idx] = null
			item.disconnect("ranout",itemConsumed)
		emit_signal("inventoryUpdated")
		return item
	return null

func consumItem(itemType,qtd):
	for idx in inventory.size():
		if inventory[idx] != null:
			if inventory[idx].type == itemType:
				inventory[idx].decumulate(qtd)
				if inventory[idx].isStorageZero():
					#inventory[idx] = null
					set_inventory_slot(idx,null)
				emit_signal("inventoryUpdated")

func itemConsumed(item):
	var dropAtConsum = item.dropContent()
	if inventory.has(item):
		set_inventory_slot(inventory.find(item),null)
		#inventory[inventory.find(item)] = null
	elif equiped.has(item):
		#equiped[equiped.find(item)] = null
		set_equiped_slot(equiped.find(item),null)
	for i in dropAtConsum:
		store_item(i,-2)#"ConsumDrop"
	emit_signal("inventoryUpdated")

func get_quantity_this_item(itemType):
	for idx in inventory.size():
		if inventory[idx] != null:
			if inventory[idx].type == itemType:
				return inventory[idx].get_quantity()
	return 0

func hasThisItemQuantity(itemType,qtd:int):
	for idx in inventory.size():
		if inventory[idx] != null:
			if inventory[idx].type == itemType:
				return inventory[idx].hasAtLastQuantity(qtd)
	return false

func equipItem(storaged_idx):
	var slotEquipable = -1
	if inventory[storaged_idx] != null:
		slotEquipable = searchEquipableSlot(inventory[storaged_idx].slotEquipable,inventory[storaged_idx])
	if slotEquipable > -1:
		var item = unstore_item(storaged_idx)
		if item != null:
			if equiped[slotEquipable] != null:
				equiped[slotEquipable].accumulate()
			else:
				#equiped[slotEquipable] = item
				set_equiped_slot(slotEquipable,item)
				equiped[slotEquipable].connect("ranout",consumItem)
			emit_signal("inventoryUpdated")
			return true
	return false

func searchEquipableSlot(itemSlotsAble,item):
	if itemSlotsAble.size() > 0:
		for slot in itemSlotsAble:
			if equiped[slot] == null:
				return slot
			elif equiped[slot].canStack(item):
				return slot
	return -1

func unequipItem(idx):
	var item = equiped[idx]
	if item != null:
		if store_item(item,-1):#"unequip"
			set_equiped_slot(idx,null)
			#equiped[idx] = null
			emit_signal("inventoryUpdated")

func dropItemStoraged(storaged_idx):
	var item = unstore_item(storaged_idx)
	if item != null:
		get_parent().drop(item)

func dropItemEquiped(storaged_idx):
	if equiped[storaged_idx] != null:
		var item = equiped[storaged_idx]
		set_equiped_slot(storaged_idx,null)
		#equiped[storaged_idx] = null
		item.disconnect("ranout",itemConsumed)
		get_parent().drop(item)

func get_principal_item():
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
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
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
	if equiped[handSlot] != null:
		if equiped[handSlot].isPlaceable():
			item = equiped[handSlot].decumulate()
			if equiped[handSlot].isStorageZero():
				#equiped[handSlot] = null
				set_equiped_slot(handSlot,null)
			emit_signal("inventoryUpdated")
			item = item.get_placeable()
			item.position = get_parent().get_position_on_eye()
			return item
	return null

func get_armor_defense_value(idx,status):
	var value = equiped[idx].get_defense() #PROBLEM TO RESOLVE
	return value[status]

func get_armor_defense():
	var equipedDef = []
	for e in equiped:
		if e != null:
			if e.isDefensive():
				equipedDef.append(e)
	return equipedDef

func get_item_consumable_status():
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
	if equiped[handSlot] != null:
		return equiped[handSlot].get_consum_status()
	return [0,0,0,0]

func get_item_inventory_info(index):
	var item = inventory[index]
	var info : String
	if item != null:
		info = "Nome : " + item.nome + "\n"
		info += item.type.desc
	return info

func get_item_equiped_info(index):
	var item = equiped[index]
	var info : String
	if item != null:
		info = "Nome : " + item.nome + "\n"
		info += item.type.desc
	return info

func isWieldableItemEquiped():
	var hand_l_has = equiped[HAND_L] != null and equiped[HAND_L].isWieldable()
	var hand_r_has = equiped[HAND_R] != null and equiped[HAND_R].isWieldable()
	return  hand_l_has or hand_r_has

func isHandsFree():
	var hand_l_has = equiped[HAND_L] == null
	var hand_r_has = equiped[HAND_R] == null
	return  hand_l_has or hand_r_has
