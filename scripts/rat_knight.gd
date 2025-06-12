extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var statemachine: Node

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
var hp = 5
var potions: int = 0
var last_movement = Vector2.UP

var battle: bool = false
var mov = 0
const movement_allowance = 0.5
var action = 0
var aiming = false

var enemy_selection = preload("res://scenes/enemy selection border.tscn")
@onready var tile_map: TileMapLayer = %TileMapLayer

@onready var attack_aim: RayCast2D = $"attack aim"

@onready var v_box: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var attack_range: ColorRect = $ColorRect

var ui: bool = false

var player_turn: bool = false

#const tile_size: Vector2 = Vector2(64,64)#64#not needed but might be later
var sprite_node_pos_tween: Tween

func _ready() -> void:
	attack_range.visible = false
	GlobalSignal.damage1.connect(update_health, CONNECT_ONE_SHOT)
	#GlobalSignal.turn_start.connect(turn_start, CONNECT_ONE_SHOT)
	#GlobalSignal.character_change.connect(character_change, CONNECT_ONE_SHOT)
	#GlobalSignal.battle_start.connect(battle_start)#when siganl is emitted it connects it to a func
	#GlobalSignal.ally_turn_started.connect(play_turn)

func _physics_process(_delta: float) -> void:
	## movement, need move func as well
	if mov <= 0.5:
		if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
			if Input.is_action_just_pressed("up") and not $up.is_colliding():
				move(Vector2.UP)
				if player_turn:
					mov += movement_allowance
			if Input.is_action_just_pressed("down") and not $doown.is_colliding():
				move(Vector2.DOWN)
				if player_turn:
					mov += movement_allowance
			if Input.is_action_just_pressed("left") and not $left.is_colliding():
				move(Vector2.LEFT)
				sprite.flip_h = true
				if player_turn:
					mov += movement_allowance
			if Input.is_action_just_pressed("right") and not $right.is_colliding():
				move(Vector2.RIGHT)
				sprite.flip_h = false
				if player_turn:
					mov += movement_allowance
	
	if mov <= 0.5 and action > 0:
		print("test")
		player_turn = false
		battle = true
	
	#if battle:
		#print("test")
	if ui:
		v_box.visible = true
	else:
		v_box.visible = false
	
	if aiming and player_turn:
		print("aim true")
		attack_aim.look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("select") and attack_aim.is_colliding():
			attack_aim.get_collider().update_health()
			var position1 = tile_map.local_to_map(get_global_mouse_position())
			aiming = false
			ui = false
			attack_range.visible = false
			#enemy_selection.instantiate()
			#enemy_selection.global_position = Vector2(position1)
			print(position1)

func move(direction: Vector2):
	
	#get current tile vector2i
	var current_tile: Vector2 = tile_map.local_to_map(global_position)
	#gettarget tile vector2i, might need to change the vector2.down/left/etc to correct cords (0, -1)
	var target_tile: Vector2 = Vector2(
		current_tile.x + direction.x, 
		current_tile.y + direction.y
		)#vector2i maked it only an interger, might be needed
	#get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
	
	if tile_data == null or not tile_data.get_custom_data("walkable"):
		return

	global_position = tile_map.map_to_local(target_tile)

	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property(sprite, "global_position", global_position, 0.15).set_trans(Tween.TRANS_SINE)

func battle_start():#gotten through the global signal bus
	battle = true

func play_turn():
	mov = 0
	print("rat_knight")
	battle = false
	player_turn = true
	ui = true
	await get_tree().create_timer(2).timeout
	#if battle and not player_turn:
	
	GlobalSignal.turn_over.emit()
	await get_tree().create_timer(5).timeout #sets timer for when ui turns off on end of turn
	print("player turn over")
	player_turn = false
	aiming = false
	ui = false
	mov = 1
	attack_range.visible = false

func character_change():
	GlobalSignal.character_change.emit()

func _on_attack_pressed() -> void:
	aiming = true
	attack_range.visible = true
	print("test")
	#if action <= 0:
		#Input.

func update_health():
	hp -= 1
	print(hp)

func add_potion():
	print("you've got potion!")
	potions += 1
	print(hp)

func _on_heal_pressed() -> void:
	if potions > 0 and hp < 5:
		hp += 1
		print("that felt great!")
		potions -= 1
	elif hp == 5:
		print("Im already feeling good")
	elif potions <= 0:
		print("I aint got that cheif")
