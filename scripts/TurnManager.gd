extends Node
class_name TurnManager

enum {ALLY_TURN, ENEMY_TURN}

signal ally_turn_started()
signal enemy_turn_started()

var game_state = ENEMY_TURN

var enemy_spawn = preload("res://scenes/enemy_rook.tscn").instantiate()

func _physics_process(delta: float) -> void:
	
	match game_state:
		ALLY_TURN: emit_signal("ally_turn_started")
		ENEMY_TURN: emit_signal("enemy_turn_started")


#@onready var scene_being_instantiated: PackedScene = preload("res://scenes/enemy_rook.tscn")
#
#var node_array = []
#
#func new_scene():
	#var instantiated_scene = scene_being_instantiated.instantiate()
	#add_child(instantiated_scene)
	#node_array.append(instantiated_scene)
#
#
#func _ready() -> void:
	#$Timer.start() 
	#await $Timer.timeout
	#add_child(enemy_spawn)
