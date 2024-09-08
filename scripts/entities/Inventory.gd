extends Node

class_name Inventory

signal inventoryUpdated

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

func store_item(item):
	var firstSlotNull = -1
	for slot in inventory.size():
		if inventory[slot] != null:
			if inventory[slot].canStack(item):
				inventory[slot].accumulate(item.getQuantity())
				inventory[slot].connect("ranout",consumItem)
				emit_signal("inventoryUpdated")
				return true
		else:
			if firstSlotNull == -1:
				firstSlotNull = slot
	if firstSlotNull == -1:
		return false
	else:
		inventory[firstSlotNull] = item
		emit_signal("inventoryUpdated")
		return true

func unstore_item(storaged_idx):
	if inventory[storaged_idx] != null:
		var item = inventory[storaged_idx].decumulate()
		if inventory[storaged_idx].isStorageZero():
			inventory[storaged_idx] = null
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
					inventory[idx] = null
				emit_signal("inventoryUpdated")

func itemConsumed(item):
	var dropAtConsum = item.dropContent()
	if inventory.has(item):
		inventory[inventory.find(item)] = null
	elif equiped.has(item):
		equiped[equiped.find(item)] = null
	for i in dropAtConsum:
		store_item(i)
	emit_signal("inventoryUpdated")

func getQuantityThisItem(itemType):
	for idx in inventory.size():
		if inventory[idx] != null:
			if inventory[idx].type == itemType:
				return inventory[idx].getQuantity()
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
				equiped[slotEquipable] = item
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
		if store_item(item):
			equiped[idx] = null
			emit_signal("inventoryUpdated")

func dropItemStoraged(storaged_idx):
	var item = unstore_item(storaged_idx)
	if item != null:
		get_parent().drop(item)

func dropItemEquiped(storaged_idx):
	if equiped[storaged_idx] != null:
		var item = equiped[storaged_idx]
		equiped[storaged_idx] = null
		item.disconnect("ranout",itemConsumed)
		get_parent().drop(item)

func getPrincipalItem():
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
	return equiped[handSlot]

func damageArmor(value,idx):
	var armor = getArmorDefense()
	armor[idx].tryApplyEffect(value)

func getHardenessAmorPieces():
	var armor = getArmorDefense()
	var hardness = []
	for a in armor:
		hardness.append(RUseable.findRelation(a.type).by_item)
	return hardness

func placeItemOnWorld(world):
	var item
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
	if equiped[handSlot] != null:
		if equiped[handSlot].isPlaceable():
			item = equiped[handSlot].decumulate()
			if equiped[handSlot].isStorageZero():
				equiped[handSlot] = null
			emit_signal("inventoryUpdated")
			item = item.getPlaceable()
			item.position = get_parent().getPositionOnEye()
			world.add_child(item)

func getArmorDefense():
	var equipedDef = []
	for e in equiped:
		if e != null:
			if e.isDefensive():
				equipedDef.append(e)
	return equipedDef

func getItemConsumableStatus():
	var handSlot = HAND_R
	if equiped[handSlot] == null:
		handSlot = HAND_L
	if equiped[handSlot] != null:
		return equiped[handSlot].getConsumStatus()
	return [0,0,0,0]

func getItemInventoryInfo(index):
	var item = inventory[index]
	var info : String
	if item != null:
		info = "Nome : " + item.nome + "\n"
		info += item.type.desc
	return info

func getItemEquipedInfo(index):
	var item = equiped[index]
	var info : String
	if item != null:
		info = "Nome : " + item.nome + "\n"
		info += item.type.desc
	return info
