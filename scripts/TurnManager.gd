extends Node
class_name TurnManager

enum  {ALLY_TURN, ENEMY_TURN, NO_TURN}

signal ally_turn_started()
signal enemy_turn_started()

var game_state = NO_TURN
var enemy_state = false
var ally_state = false

var enemy_spawn = preload("res://scenes/enemy_rook.tscn").instantiate()


func _ready() -> void:
	GlobalSignal.battle_start.connect(battle_start)
	GlobalSignal.ally_turn_started.connect(ally_turn)


func _physics_process(delta: float) -> void:

	match game_state:
		NO_TURN: 
			ally_state = false
			enemy_state = false
		ALLY_TURN: 
			ally_state = true
			GlobalSignal.ally_turn_started.emit()
		
		ENEMY_TURN: 
			enemy_state = true
			GlobalSignal.enemy_turn_started.emit()
	
	if enemy_state:
		enemy_turn()
	if ally_state:
		ally_turn()

func enemy_turn():
	game_state = ENEMY_TURN
	

func ally_turn():
	game_state = ALLY_TURN
	

func battle_start():
	game_state = ENEMY_TURN

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
