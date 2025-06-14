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

var characters

var enemy_spawn = preload("res://scenes/enemy_rook.tscn").instantiate()



var battle: bool = false

func _ready() -> void:
	
	GlobalSignal.battle_start.connect(battle_start, CONNECT_ONE_SHOT)
	#GlobalSignal.enemy_turn_started.connect(enemy_turn, CONNECT_ONE_SHOT)
	GlobalSignal.turn_over.connect(turn_over, CONNECT_ONE_SHOT)
	#GlobalSignal.turn_start.connect(turn_start, CONNECT_ONE_SHOT)
	#GlobalSignal.character_change.connect(character_change, CONNECT_ONE_SHOT)
	GlobalSignal.enemy_turn_over.connect(enemy_turn_over, CONNECT_ONE_SHOT)
	
	get_battlers()


#func _physics_process(delta: float) -> void:
	#print(characters)
	
func _process(delta: float) -> void:
	if battle:
		for character in characters:
			if character == null:
				character = characters.front()
			battle = false
			var timer = 0
			if character.is_in_group("player"):
				timer = 5
			elif character.is_in_group("enemy"):
				timer = 1
			character.play_turn()
			await character.play_turn(); "completed"
			await get_tree().create_timer(timer).timeout
			battle = true

func battle_start():
	battle = true

func turn_over():
	pass
	#battle = true

func get_battlers():
	characters = get_children()

#func character_change():
	#chachange = false
	#current += add 
	
func enemy_turn_over():
	chachange = false
