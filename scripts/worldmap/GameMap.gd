extends Node2D

@export var inventoryInterface : Control
@export var skillcallInterface : LineEdit

#@onready var map = $TileMap
var generator = TerrainGenerate.new()

func _ready():
	print("Game Map Ready")
	GameConfig.Interface_SkillCall = skillcallInterface
	GameConfig.Interface_Inventory = inventoryInterface
