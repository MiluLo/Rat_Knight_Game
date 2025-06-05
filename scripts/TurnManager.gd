extends Node
class_name TurnManager

enum {ALLY_TURN, ENEMY_TURN}

signal ally_turn_started()
signal enemy_turn_started()

var game_state = ENEMY_TURN
func _physics_process(delta: float) -> void:
	
	match game_state:
		ALLY_TURN: emit_signal("ally_turn_started")
		ENEMY_TURN: emit_signal("enemy_turn_started")


func _ready() -> void:
	pass
