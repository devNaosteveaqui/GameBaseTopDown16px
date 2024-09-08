extends Node2D

@export var inventoryInterface : Control

@onready var map = $TileMap
var generator = TerrainGenerate.new()


func _ready():
	var tiles = generator.generate_floor(Game.MAP_WIDTH,Game.MAP_HEIGTH,-Game.MAP_WIDTH/2,-Game.MAP_HEIGTH/2)
	map.render(tiles)
	map.spawn_on_map(Spawner.createSpawner(Entities.GREENSLIME,map), 100,100)
	spawnPlayer()

func spawnPlayer():
	var player = Entity.create_entity(Entities.HUMAN)
	var playercontrol = load("res://scenes/entities/PlayerControl.tscn").instantiate()
	playercontrol.inventoryUI = inventoryInterface
	player.add_child(playercontrol)
	player.add_child(Camera2D.new())
	map.spawn_on_map(player,100,100)
