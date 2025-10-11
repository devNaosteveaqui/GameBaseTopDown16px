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

func create_inventory():
	inventory.resize(20)
	equiped.resize(12)

func store_item(item,typeStore):
	var firstSlotNull = -1
	for slot in inventory.size():
		if not is_inventory_slot_empty(slot):
			if inventory[slot].canStack(item):
				inventory[slot].accumulate(item.get_quantity())
				inventory[slot].connect("ranout",itemConsumed)
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
		var item = inventory[storaged_idx].decumulate()
		if inventory[storaged_idx].isStorageZero():
			set_inventory_slot(storaged_idx,null)
			item.disconnect("ranout",itemConsumed)
		emit_signal("inventoryUpdated")
		return item
	return null

func consumItem(itemType,qtd):
	for idx in inventory.size():
		if not is_inventory_slot_empty(idx):
			if is_type_item_inventory(idx,itemType):
				inventory[idx].decumulate(qtd)
				if inventory[idx].isStorageZero():
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
				return inventory[idx].get_quantity()
	return 0

func hasThisItemQuantity(itemType,qtd:int):
	for idx in inventory.size():
		if not is_inventory_slot_empty(idx):
			if is_type_item_inventory(idx,itemType):
				return inventory[idx].hasAtLastQuantity(qtd)
	return false

func getItemConsumableEquipedSlotIdx():
	if not is_equip_slot_empty(HAND_L):
		if equiped[HAND_L].consumable :
			return HAND_L
		if equiped[HAND_L].has_one_slot() and (not equiped[HAND_L].is_empty()):
			return HAND_L
	elif not is_equip_slot_empty(HAND_R):
		if equiped[HAND_R].consumable :
			return HAND_R
		if equiped[HAND_R].has_one_slot() and (not equiped[HAND_R].is_empty()):
			return HAND_R
	return -1

func getItemContainerEquipedSlotIdx():
	if not is_equip_slot_empty(HAND_L):
		if equiped[HAND_L].canContainItem :
			return HAND_L
	elif not is_equip_slot_empty(HAND_R):
		if equiped[HAND_R].canContainItem :
			return HAND_R
	return -1

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
		slotEquipable = isEquipableAtSlot(inventory[storaged_idx].slotEquipable,inventory[storaged_idx],slot_idx)
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
			elif equiped[slot].canStack(item):
				return slot
	return -1

func isEquipableAtSlot(itemSlotsAble,item,slotTarget):
	if (itemSlotsAble.has(slotTarget) and itemSlotsAble.size() > 0):
		for slot in itemSlotsAble:
			return (is_equip_slot_empty(slotTarget) or equiped[slotTarget].canStack(item))
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
	var handSlot = HAND_R if is_equip_slot_empty(HAND_R) else HAND_L
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
	var handSlot = HAND_R if is_equip_slot_empty(HAND_R) else HAND_L
	if not is_equip_slot_empty(handSlot):
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

func useContainer(slotIdx,onTarget : Entity):
	var item : Item = equiped[slotIdx]
	var itens_extracted = RExtract.findRelation(onTarget.type).extract
	if itens_extracted != null:
		item.set_drops(itens_extracted)
		
		for item_extracted in itens_extracted:
			var sprite_container_filled = RContents.findRelation(item.type,item_extracted[1]).sprite
			if sprite_container_filled != null:
				item.set_sprite(sprite_container_filled)

func useConsumable(slotIdx,onTarget : Entity):
	#Lógica de consumir um item consumivel
	#Aplicar efeitos de uso do item
	
	var item : Item = equiped[slotIdx]
	var stat : Status = onTarget.get_status_class()
	
	stat.applyEffect(Estatisticas.createItemMetric(-1),item.get_status_effect())
	#Remover 1 unidade do item
	var resto : Item = equiped[slotIdx].decumulate()
	if equiped[slotIdx].isStorageZero():
		if resto.type != equiped[slotIdx].type:
			store_item(resto,Estatisticas.ITENS.EXTRAIDOS)
		set_equiped_slot(slotIdx,null)

func get_armor_defense_value(idx,status):
	var value = equiped[idx].get_defense() #PROBLEM TO RESOLVE
	return value[status]

func get_armor_defense():
	var equipedDef = []
	for e in equiped:
		if e != null:
			if e.has_method("isDefensive"):
				#Precisa verificar caso o item não seja uma vestimenta ou tenha a propriedade
				if e.isDefensive():
					equipedDef.append(e)
	return equipedDef

func get_item_consumable_status():
	var handSlot = HAND_R
	if is_equip_slot_empty(handSlot):
		handSlot = HAND_L
	if not is_equip_slot_empty(handSlot):
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
	if not is_equip_slot_empty(index):
		info = "Nome : " + item.nome + "\n"
		info += item.type.desc
	return info

func isWieldableItemEquiped():
	var hand_l_has = not is_equip_slot_empty(HAND_L) and equiped[HAND_L].isWieldable()
	var hand_r_has = not is_equip_slot_empty(HAND_R) and equiped[HAND_R].isWieldable()
	return  hand_l_has or hand_r_has

func isHandsFree():
	var hand_l_has = is_equip_slot_empty(HAND_L)
	var hand_r_has = is_equip_slot_empty(HAND_R)
	return  hand_l_has or hand_r_has
