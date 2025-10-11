extends Control

@export var estatisticas : VBoxContainer

func showEstatisticas(entity):
	for child in estatisticas.get_children():
		child.queue_free()
	
	for i in Estatisticas.ESTATISTICAS_GROUP:
		#Por enquanto só será exibido as estatisticas gerais
		if i == Estatisticas.ESTATISTICAS_GROUP.find_key(Estatisticas.ESTATISTICAS_GROUP.DETALHADO):
			continue
		var label_w_greater = 0
		var class_item_w_greater = 0
		
		for j in Estatisticas.ESTATISTICAS_CLASS:
			var hbox = HBoxContainer.new()
			var labelClass = Label.new()
			
			labelClass.text = j
			
			hbox.add_child(labelClass)
			estatisticas.add_child(hbox)
			
			var vbox_a = VBoxContainer.new()
			var vbox_b = VBoxContainer.new()
			
			
			
			for k in entity.estatisticas.estatisticas[Estatisticas.ESTATISTICAS_GROUP[i]][Estatisticas.ESTATISTICAS_CLASS[j]].keys():
				
				var labelClassItem = Label.new()
				var value = Label.new()
				
				labelClassItem.text = str(Estatisticas.enums[Estatisticas.ESTATISTICAS_CLASS[j]].keys()[k])
				value.text = str(entity.estatisticas.estatisticas[Estatisticas.ESTATISTICAS_GROUP[i]][Estatisticas.ESTATISTICAS_CLASS[j]][k])
				
				vbox_a.add_child(labelClassItem)
				vbox_b.add_child(value)
				
			
			hbox.add_child(vbox_a)
			hbox.add_child(vbox_b)
			
			class_item_w_greater = max(class_item_w_greater,vbox_a.size.x)
			label_w_greater = max(label_w_greater,labelClass.size.x)
			
			vbox_a.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_a.size_flags_stretch_ratio = 1.0
			vbox_b.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_b.size_flags_stretch_ratio = 1.0
			
			labelClass.size_flags_vertical = Control.SIZE_EXPAND_FILL
			labelClass.size_flags_stretch_ratio = float(entity.estatisticas.estatisticas[Estatisticas.ESTATISTICAS_GROUP[i]][Estatisticas.ESTATISTICAS_CLASS[j]].keys().size())
			
			hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.size_flags_stretch_ratio = 1.0
			
			estatisticas.add_child(HSeparator.new())
		
		for child in estatisticas.get_children():
			if child is not HSeparator:
				child.get_child(0).custom_minimum_size.x = label_w_greater
				child.get_child(1).custom_minimum_size.x = class_item_w_greater
