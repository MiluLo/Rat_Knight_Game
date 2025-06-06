extends Node2D


@export var turnManager: Node
@onready var board: TileMapLayer = $TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func _on_ally_turn_started():
	pass


func _on_enemy_turn_started():
	print("hello")
