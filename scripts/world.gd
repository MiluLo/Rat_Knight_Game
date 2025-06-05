extends Node2D


@export var turnManager: Node
@onready var board: TileMapLayer = $TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turnManager.connect("ally_turn_started", _on_ally_turn_started)
	turnManager.connect("enemy_turn_started", _on_enemy_turn_started)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_ally_turn_started():
	pass


func _on_enemy_turn_started():
	var enemies = board.get_enemy()
	if enemies.empty():
		print("lonely")
	else: 
		print("hello")
