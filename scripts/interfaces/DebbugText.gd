extends VBoxContainer

@export var Coordenadas : Label
@export var FPSAndFrameTime : Label
@export var Physics : Label
@export var Process : Label
@export var Memory : Label
@export var Rendering : Label

var logs : Array
var log_game : Dictionary

#func _ready() -> void:
	#_player_position()

#@warning_ignore("unused_parameter")
#func _process(delta: float) -> void:
	#_analytics_info()

func _player_position(x:float=0.0,y:float=0.0):
	$Coord.text = "Coordinates (x,y) : ( " + str(round(x*100)/100.0) + ", " + str(round(y*100)/100.0) + ")"
	#Coordernadas.get_text = "x = " + str("%.3f" % snapped(x,0.001)) + ', y = ' + str("%.3f" % snapped(y,0.001))

func _analytics_info():
	collect_data()
	data_analysis()
	show_data()
	logs.append(log_game.duplicate())
	if get_log_value("fps") > 59:
		$OBS.text = "Otimização Perfeita!! DevGame Perfeito!!"
		$OBS.add_theme_color_override("font_color",Color.GREEN)
		$OBS.add_theme_color_override("font_outline_color",Color.BLACK)
		$OBS.add_theme_constant_override("outline_size",2)
	elif get_log_value("fps") > 30:
		$OBS.text = "Voltamos para os anos 2010... até que foram bons tempos."
		$OBS.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
		$OBS.add_theme_color_override("font_outline_color",Color.BLACK)
		$OBS.add_theme_constant_override("outline_size",2)
	else:
		$OBS.text = "A otimização deve ter sido feita em Malbolge"
		$OBS.add_theme_color_override("font_color",Color.DARK_RED)
		$OBS.add_theme_color_override("font_outline_color",Color.BLACK)
		$OBS.add_theme_constant_override("outline_size",2)

func show_data():
	FPSAndFrameTime.text = "FPS ( Frame Time | Physics Frame Time ): " + get_log_flag("fps") + str(get_log_value("fps"))
	FPSAndFrameTime.text += " ( " + get_log_flag("frame_time") + str(get_log_value("frame_time") * 1000.0) + " ms | "
	FPSAndFrameTime.text += get_log_flag("physics_frame_time") + str(get_log_value("physics_frame_time")*1000.0) + " ms )"
	
	Physics.text = "Active Physics 2D Objects ( Collision Pairs | Island Count ): " + get_log_flag("active_physics_2d_objects") + str(get_log_value("active_physics_2d_objects"))
	Physics.text += " ( " + get_log_flag("collision_pairs") + str(get_log_value("collision_pairs")) + " | "
	Physics.text += get_log_flag("island_count") + str(get_log_value("island_count")) + " )"
	
	Process.text = "Objects ( Nodes | Orphans ): " + get_log_flag("objects") + str(get_log_value("objects")) + " ( "
	Process.text += get_log_flag("nodes") + str(get_log_value("nodes")) + " | "
	Process.text += get_log_flag("orphans") + str(get_log_value("orphans")) + " )"
	
	var video_men = get_log_value("memory_video")/(1024.0 * 1024.0)
	Memory.text = "Video mem (MB): " + get_log_flag("memory_video") + str(round(video_men*100)/100.0)
	
	Rendering.text = "Draw calls: " + get_log_flag("draw_calls") + str(get_log_value("draw_calls")) + " | Objects In Frame: "
	Rendering.text += get_log_flag("objects_in_frame") + str(get_log_value("objects_in_frame"))

func collect_data():
	set_log_value("fps",Engine.get_frames_per_second())
	set_log_value("frame_time",Performance.get_monitor(Performance.TIME_PROCESS))
	set_log_value("physics_frame_time",Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS))
	
	set_log_value("active_physics_2d_objects",Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS))
	set_log_value("collision_pairs",Performance.get_monitor(Performance.PHYSICS_2D_COLLISION_PAIRS))
	set_log_value("island_count",Performance.get_monitor(Performance.PHYSICS_2D_ISLAND_COUNT))
	
	set_log_value("objects",Performance.get_monitor(Performance.OBJECT_COUNT))
	set_log_value("nodes",Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	set_log_value("orphans",Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	
	set_log_value("memory_video",Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
	set_log_value("memory_static",Performance.get_monitor(Performance.MEMORY_STATIC))
	set_log_value("memory_message_buffer",Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX))
	set_log_value("memory_texture",Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))
	
	set_log_value("draw_calls",Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	set_log_value("objects_in_frame",Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))

func set_log_value(log_ref:String,log_value):
	log_game[log_ref] = {'value' : log_value}

func set_log_flag(log_ref):
	log_game[log_ref]['flag'] = "<!>"
	log_game["flag_count"] = 1 + (log_game["flag_count"] if log_game.has("flag_count") else 0)

func get_log_value(log_ref):
	return log_game[log_ref]['value']

func get_log_flag(log_ref):
	if log_game[log_ref].has('flag'):
		return log_game[log_ref]['flag']
	return ''

func get_log_flag_count():
	if log_game.has("flag_count"):
		return log_game["flag_count"]
	return 0

func avaluate_condition(log_ref:String,tier,value_condition_red,value_condition_yellow):
	if get_log_value(log_ref) > value_condition_red:
		set_log_flag(log_ref)
		tier.r += 1
	elif get_log_value(log_ref) > value_condition_yellow:
		tier.y += 1
	return tier

func define_color_flag(tier:Dictionary):
	if tier.r > 0:
		return Color.RED
	elif tier.y > 0:
		return Color.YELLOW
	else:
		return Color.GREEN

func set_label_style(lbl:Label,color:Color):
	lbl.add_theme_color_override("font_color",color)
	lbl.add_theme_color_override("font_outline_color",Color.BLACK)
	lbl.add_theme_constant_override("outline_size",2)

func data_analysis():
	log_game["flag_count"] = 0
	var color_flag = Color.WHITE
	var tier = {'r':0,'y':0}
	
	tier = avaluate_condition("frame_time",tier,0.02,0.01)
	tier = avaluate_condition("physics_frame_time",tier,0.0166,0.0050)
	color_flag = define_color_flag(tier)
	
	set_label_style(FPSAndFrameTime,color_flag)
	color_flag = Color.WHITE
	tier = {'r':0,'y':0}
	
	tier = avaluate_condition("active_physics_2d_objects",tier,500,200)
	tier = avaluate_condition("collision_pairs",tier,500,100)
	tier = avaluate_condition("island_count",tier,200,50)
	color_flag = define_color_flag(tier)
	
	set_label_style(Physics,color_flag)
	color_flag = Color.WHITE
	tier = {'r':0,'y':0}
	
	tier = avaluate_condition("objects",tier,6000,2000)
	tier = avaluate_condition("nodes",tier,4000,1500)
	tier = avaluate_condition("orphans",tier,100,1)
	color_flag = define_color_flag(tier)
	
	set_label_style(Process,color_flag)
	color_flag = Color.WHITE
	tier = {'r':0,'y':0}
	
	tier = avaluate_condition("draw_calls",tier,700,300)
	tier = avaluate_condition("objects_in_frame",tier,2500,1000)
	color_flag = define_color_flag(tier)
	
	set_label_style(Rendering,color_flag)
	color_flag = Color.WHITE
	tier = {'r':0,'y':0}
