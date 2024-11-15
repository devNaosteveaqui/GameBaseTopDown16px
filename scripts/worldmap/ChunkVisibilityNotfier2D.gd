extends Node2D

@export var TILE_SIZE : Vector2i
@export var CHUNK_SIZE_IN_TILES : Vector2i
@export var NOTIFIER_SIZE_IN_CHUNKS : Vector2i
@export var ENABLER_SIZE_IN_NOTIFIER : Vector2i
@export var AREAS_VISIVEIS : Array

var visible_map : Array = []
var chunk_count : int

func _ready() -> void:
	var notifier_size = Vector2i(TILE_SIZE.x*CHUNK_SIZE_IN_TILES.x*NOTIFIER_SIZE_IN_CHUNKS.x,TILE_SIZE.y*CHUNK_SIZE_IN_TILES.y*NOTIFIER_SIZE_IN_CHUNKS.y)
	var enabler_size = Vector2i(notifier_size.x*ENABLER_SIZE_IN_NOTIFIER.x,notifier_size.y*ENABLER_SIZE_IN_NOTIFIER.y)
	var chunks_count_on = Vector2i(Game.MAP_WIDTH/CHUNK_SIZE_IN_TILES.x,Game.MAP_HEIGTH/CHUNK_SIZE_IN_TILES.y)
	
	chunk_count = chunks_count_on.x*chunks_count_on.y
	var cve_count = chunk_count/16
	var cvn_count = chunk_count/4
	
	var cve_count_on = Vector2i(chunks_count_on.x/4,chunks_count_on.y/4)
	var cvn_count_on = Vector2i(chunks_count_on.x/2,chunks_count_on.y/2)
	
	for cn in cve_count:
		var markerA : AreaProcessManager = AreaProcessManager.new()
		var cve : VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()
		
		markerA.add_child(cve)
		add_child(markerA)
		
		visible_map.append({
			'enabler': cve,
			'notifiers' : [],
			'markers_notifiers' : [],
			'marker_enabler' : markerA,
			'notifiers_visibles' : []
		})
		
		var x = -enabler_size.x/2
		var y = -enabler_size.y/2
		cve.rect = Rect2(x,y,enabler_size.x,enabler_size.y)
		cve.screen_exited.connect(chunk_discharge.bind(visible_map.size()-1,-1))
		cve.screen_entered.connect(chunk_charge.bind(visible_map.size()-1,-1))
		#var cs = CollisionShape2D.new()
		#cve.add_child(cs)
		#cs.shape = RectangleShape2D.new()
		#cs.shape.size = cve.rect.size
		markerA.is_master = true
		markerA.monitored_nodes_group = "mapM_"+str(cn)+"_all"
		markerA.add_to_group(markerA.monitored_nodes_group)
		markerA.position.x = ( cn%cve_count_on.x - cve_count_on.x/2)*(enabler_size.x) + enabler_size.x/2
		markerA.position.y = ( cn/cve_count_on.y - cve_count_on.y/2)*(enabler_size.y) + enabler_size.y/2
		markerA.monitored_area.position.x = markerA.position.x + cve.rect.position.x
		markerA.monitored_area.position.y = markerA.position.y + cve.rect.position.y
		markerA.monitored_area.size = cve.rect.size
		for cn_i in 4:
			var submarker : AreaProcessManager = AreaProcessManager.new()
			submarker.name = "submarker_" + str(cn) + "_" + str(cn_i)
			var cvn : VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
			
			submarker.add_child(cvn)
			add_child(submarker)
			
			visible_map.back().notifiers.append(cvn)
			visible_map.back().markers_notifiers.append(submarker)
			
			var x_cn = -(notifier_size.x)/2
			var y_cn = -(notifier_size.y)/2
			cvn.rect = Rect2(x_cn,y_cn,notifier_size.x,notifier_size.y)
			cvn.screen_exited.connect(chunk_discharge.bind(cn,cn_i))
			cvn.screen_entered.connect(chunk_charge.bind(cn,cn_i))
			
			var notifier_index = cn_i%(ENABLER_SIZE_IN_NOTIFIER.x*ENABLER_SIZE_IN_NOTIFIER.y)
			
			submarker.monitored_nodes_group = "mapM_"+str(cn)+"_"+str(cn_i)
			submarker.add_to_group(submarker.monitored_nodes_group)
			submarker.add_to_group(markerA.monitored_nodes_group)
			submarker.position.x = markerA.position.x + ((notifier_index%ENABLER_SIZE_IN_NOTIFIER.x)*2 - 1)*notifier_size.x/2
			submarker.position.y = markerA.position.y + ((notifier_index/ENABLER_SIZE_IN_NOTIFIER.y)*2 - 1)*notifier_size.y/2
			
			submarker.monitored_area.position.x = submarker.position.x + cvn.rect.position.x
			submarker.monitored_area.position.y = submarker.position.y + cvn.rect.position.y
			#submarker.monitored_area.position.x = markerA.position.x + ((notifier_index%ENABLER_SIZE_IN_NOTIFIER.x)*2 - 1)*notifier_size.x
			#submarker.monitored_area.position.y = markerA.position.y + ((notifier_index/ENABLER_SIZE_IN_NOTIFIER.y)*2 - 1)*notifier_size.y
			submarker.monitored_area.size.x = notifier_size.x
			submarker.monitored_area.size.y = notifier_size.y

			var cvn_cs : CollisionShape2D = CollisionShape2D.new()
			cvn.add_child(cvn_cs)
			cvn_cs.shape = RectangleShape2D.new()
			cvn_cs.shape.size = cvn.rect.size


func chunk_discharge(cn:int,ce:int):
	if ce == -1:
		visible_map[cn].marker_enabler.screen_off()
	elif visible_map[cn].notifiers_visibles.has(ce):
		visible_map[cn].notifiers_visibles.remove_at(visible_map[cn].notifiers_visibles.find(ce))
		visible_map[cn].markers_notifiers[ce].screen_off()
		AREAS_VISIVEIS.remove_at(AREAS_VISIVEIS.find(visible_map[cn]))
		get_parent().unload_map(visible_map[cn].markers_notifiers[ce].get_monitored_area())
	else:
		print("Já está descarregado")

func chunk_charge(cn:int,ce:int):
	if ce == -1:
		visible_map[cn].marker_enabler.screen_on()
	elif not visible_map[cn].notifiers_visibles.has(ce):
		visible_map[cn].notifiers_visibles.append(ce)
		visible_map[cn].markers_notifiers[ce].screen_on()
		AREAS_VISIVEIS.append(visible_map[cn])
		get_parent().load_map(visible_map[cn].markers_notifiers[ce].get_monitored_area())
	else:
		print("Já esta carregado")

func get_chunk_groups(pos:Vector2):
	for area in AREAS_VISIVEIS:
		for c in area.notifiers_visibles:
			var monitored_area = area.markers_notifiers[c].get_monitored_area()
			if vector_in_area(pos,monitored_area):
				return [area.markers_notifiers[c].monitored_nodes_group,monitored_area]
		
func vector_in_area(pos:Vector2,rect:Rect2):
	var r : bool = false
	r = rect.position.x - pos.x < 0 && pos.x < rect.position.x + rect.size.x
	r = r && rect.position.y - pos.y < 0 && pos.y < rect.position.y + rect.size.y
	#print("Object: ",pos,", Area: ",rect,", Is in: ",r)
	return r
