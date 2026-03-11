extends Node

class_name UseableInterface

static func use_liquid_container(container,target):
	#Verifica se o container está vazio ou não
	if ItemInterface.is_empty(container,0):
		var itens_extracted = RExtract.findRelation(target.type).extract
		if itens_extracted != null:
			#item.set_drops(itens_extracted)
			for item_extracted in itens_extracted:
				ItemInterface.add_content_to_container(container,item_extracted)
				var sprite_container_filled = RContents.findRelation(container.type,item_extracted[1]).sprite
				if sprite_container_filled != null:
					container.set_sprite(sprite_container_filled)
	else:
		var stat : Status = target.get_status_class()
		var content = ItemInterface.get_item_in_inventory(container,0)
		var content_data = ItemInterface.create_data_from_type(content[1],container.lastEntityCollect)
		StatusInterface.applyEffect(Estatisticas.createItemMetric(-1),ItemInterface.get_status_effect(content_data),stat)
		ItemInterface.remove_content_from_container(container)
		container.set_sprite(container.type.sprite)

static func use_consumable(consumable,target):
	var stat : Status = target.get_status_class()
	
	StatusInterface.applyEffect(Estatisticas.createItemMetric(-1),ItemInterface.get_status_effect(consumable),stat)
	ItemInterface.decumulate(consumable)
