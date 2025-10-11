extends Node2D

@export var inventoryInterface : Control
@export var skillcallInterface : LineEdit
@export var gameMensage : Panel
@export var gameDebug : VBoxContainer
@export var estatisticas : Control
#@onready var map = $TileMap
var generator = TerrainGenerate.new()

func _ready():
	GameConfig.Interface_SkillCall = skillcallInterface
	GameConfig.Interface_Inventory = inventoryInterface
	GameConfig.Game_Notification = gameMensage
	GameConfig.Debug_View = gameDebug
	GameConfig.Interface_Statistics= estatisticas
