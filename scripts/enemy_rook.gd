extends CharacterBody2D

const tile_size: Vector2 = Vector2(64,64)#64

@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var astar_grid: AStarGrid2D
@onready var tile_map: TileMapLayer = %TileMapLayer
var is_moving: bool

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var mov = 0
const movement_allowance = 1

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
	
	GlobalSignal.enemy_turn_started.connect(play_turn)
	GlobalSignal.turn_start.connect(turn_start)
	
	

func _process(_delta: float) -> void:
	if is_moving:
		return
		
	move()


func move():
	if mov == 0:
		var path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(player.global_position)
			)
		
		path.pop_front()
		
		if path.size() == 1:
			print("stand ready for my arrival faggot")
			return
		
		if path.is_empty():
			print("cant find path")
			return

		var original_position = Vector2(global_position)
		
		global_position = tile_map.map_to_local(path[0])
		sprite.global_position = original_position
		
		is_moving = true
		
	#hello


func _physics_process(_delta: float) -> void:
	if is_moving:
		sprite.global_position = sprite.global_position.move_toward(global_position,1)
		
		if sprite.global_position != global_position:
			return
		
		is_moving = false
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	add_to_group("Enemy")
	GlobalSignal.battle_start.emit()
	mov += movement_allowance#will need to change so its only in the fight stage




func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func play_turn():
	await get_tree().create_timer(2).timeout

	GlobalSignal.turn_over.emit()


func turn_start():
	print("working")
