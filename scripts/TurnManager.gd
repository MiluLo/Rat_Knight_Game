extends Node
class_name TurnManager

enum  {ALLY_TURN, ENEMY_TURN, NO_TURN}



var game_state = NO_TURN
var enemy_state = false
var ally_state = false

var current = 0 
var chachange = true

var active_character

var enemy_spawn = preload("res://scenes/enemy_rook.tscn").instantiate()


func _ready() -> void:
	
	GlobalSignal.ally_turn_started.connect(ally_turn)
	GlobalSignal.enemy_turn_started.connect(enemy_turn, CONNECT_ONE_SHOT)
	GlobalSignal.turn_over.connect(turn_over, CONNECT_ONE_SHOT)
	GlobalSignal.turn_start.connect(turn_start, CONNECT_ONE_SHOT)
	GlobalSignal.character_change.connect(character_change, CONNECT_ONE_SHOT)
	
	get_battlers()


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
	
	

func _process(delta: float) -> void:
	if chachange:
		active_character.turn_start()
	else:
		return




func enemy_turn():
	game_state = ENEMY_TURN
	

func ally_turn():
	game_state = ALLY_TURN
	



func turn_over():
	
	var new_index = active_character.get_index() + 1
	await get_tree().create_timer(2).timeout
	active_character = new_index
	
	print(active_character)
	
func turn_start():
	print("working1")
	active_character.method(turn_start)
	

func get_battlers():
	active_character = get_child(0)

func character_change():
	chachange = false
