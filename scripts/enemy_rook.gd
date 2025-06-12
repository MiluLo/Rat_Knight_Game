extends CharacterBody2D

const tile_size: Vector2 = Vector2(64,64)#64

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

@export var statemachine: Node

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var hp = 2
var attack1: int

var astar_grid: AStarGrid2D
@onready var tile_map: TileMapLayer = %TileMapLayer
@onready var attack_aim: RayCast2D = $attack_aim

var is_moving: bool

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var mov = 0
const movement_allowance = 2
var battle: bool = false

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(256,256)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position

	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(x + region_position.x,y + region_position.y)
			var tile_data = tile_map.get_cell_tile_data(tile_position)
			if tile_data == null or not tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)
	GlobalSignal.battle_start.connect(battle_start, CONNECT_ONE_SHOT)

func _process(_delta: float) -> void:
	if is_moving:
		return


func move():
	if mov == 0:
		var enemies = get_tree().get_nodes_in_group("enemy")
		var occupied_positions = []

		for enemy in enemies:
			if enemy == self:
				continue

			occupied_positions.append(tile_map.local_to_map(enemy.global_position))
		
		for occupied_position in occupied_positions:
			astar_grid.set_point_solid(occupied_position)#set enemies solid

		var path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(player.global_position)
			)

		for occupied_position in occupied_positions:
			astar_grid.set_point_solid(occupied_position, false)#unset enemies

		path.pop_front()

		if path.size() == 1:
			attack()
			print("stand ready for my arrival faggot")
			return

		if path.is_empty():
			print("cant find path")
			return

		var original_position = Vector2(global_position)
		
		global_position = tile_map.map_to_local(path[0])
		sprite.global_position = original_position
		
		is_moving = true
		
		if path.size() == 2:
			return
	mov += movement_allowance#will need to change so its only in the fight stage


func _physics_process(_delta: float) -> void:
	if is_moving:
		sprite.global_position = sprite.global_position.move_toward(global_position,1)
		
		if sprite.global_position != global_position:
			return
		
		is_moving = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	#add_to_group("Enemy")
	GlobalSignal.battle_start.emit()
	
	area.set_deferred("monitoring", false)

func play_turn():
	#await get_tree().create_timer(2).timeout
	mov = 0
	print("ENEMY")
	move()
	await get_tree().create_timer(4).timeout
	attack1 = 0
	attack()
	#GlobalSignal.turn_over.emit()

	print("turn over")

func attack():
	if attack1 == 0:
		attack_aim.look_at(player.global_position)
		if attack_aim.is_colliding():
			attack_aim.enabled = false
			attack1 += 1
			attack_aim.get_collider().update_health()
			GlobalSignal.damage1.emit()
		print("you are run down")

func update_health():
	hp -= 1
	print("ahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
	if hp <= 0:
		queue_free()

func battle_start():
	area.set_deferred("monitoring", false)
