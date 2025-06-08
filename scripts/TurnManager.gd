extends Node
class_name TurnManager

enum  {ALLY_TURN, ENEMY_TURN, NO_TURN}



var game_state = NO_TURN
var enemy_state = false
var ally_state = false

var current: int = 0
var add = 1
var chachange = false
var enechange = true

var active_character

var enemy_spawn = preload("res://scenes/enemy_rook.tscn").instantiate()


func _ready() -> void:
	
	#GlobalSignal.ally_turn_started.connect(ally_turn)
	GlobalSignal.enemy_turn_started.connect(enemy_turn, CONNECT_ONE_SHOT)
	GlobalSignal.turn_over.connect(turn_over, CONNECT_ONE_SHOT)
	GlobalSignal.turn_start.connect(turn_start, CONNECT_ONE_SHOT)
	GlobalSignal.character_change.connect(character_change, CONNECT_ONE_SHOT)
	GlobalSignal.enemy_turn_over.connect(enemy_turn_over, CONNECT_ONE_SHOT)
	
	get_battlers(0)


func _physics_process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	print(enemies)
	enemy_turn()
	#match game_state:
		#NO_TURN: 
			#ally_state = false
			#enemy_state = false
		#ALLY_TURN: 
			#ally_state = true
			#GlobalSignal.ally_turn_started.emit()
		#
		#ENEMY_TURN: 
			#enemy_state = true
			#GlobalSignal.enemy_turn_started.emit()
	
	#if chachange:
		#print("BS")
		#active_character.turn_start()
	
		
	
	#print(active_character)
	

func enemy_turn():
	get_tree().call_group("enemies", "move")
















func _process(delta: float) -> void:
	turn_start()




func turn_over():
	chachange = false
	var new_index: int = active_character.get_index() + add
	add += 1
	
	get_battlers(new_index)
	
	
func turn_start():
	if chachange:
		active_character.turn_start()
	
	if not chachange:
		await get_tree().create_timer(3).timeout
		chachange = true
	
	

func get_battlers(new_index):
	active_character = get_child(new_index)

func character_change():
	chachange = false
	current += add 
	
	
func enemy_turn_over():
	chachange = false
	
