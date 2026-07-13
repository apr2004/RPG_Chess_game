extends Sprite2D

const BOARD_SIZE = 8
const CELL_WIDTH = 18

const TEXTURE_HOLDER = preload("res://Scenes/texture_holder.tscn")

# black pieces
const BLACK_BISHOP = preload("res://Assets/black_bishop.png")
const BLACK_KING = preload("res://Assets/black_king.png")
const BLACK_KNIGHT = preload("res://Assets/black_knight.png")
const BLACK_PAWN = preload("res://Assets/black_pawn.png")
const BLACK_QUEEN = preload("res://Assets/black_queen.png")
const BLACK_ROOK = preload("res://Assets/black_rook.png")

# white pieces
const WHITE_BISHOP = preload("res://Assets/white_bishop.png")
const WHITE_KING = preload("res://Assets/white_king.png")
const WHITE_KNIGHT = preload("res://Assets/white_knight.png")
const WHITE_PAWN = preload("res://Assets/white_pawn.png")
const WHITE_QUEEN = preload("res://Assets/white_queen.png")
const WHITE_ROOK = preload("res://Assets/white_rook.png")

# available moves 
const PIECE_MOVE = preload("res://Assets/Piece_move.png")

# turns
const TURN_BLACK = preload("res://Assets/turn-black.png")
const TURN_WHITE = preload("res://Assets/turn-white.png")

@onready var pieces = $Pieces
@onready var dots = $Dots
@onready var turn = $Turn

# variables
# -6 = black king
# -5 = black queen
# -4 = black rook
# -3 = black bishop
# -2 = black knight
# -1 = black pawn
# 0 = empty
# 6 = white king
# 5 = white queen
# 4 = white rook
# 3 = white bishop
# 2 = white knight
# 1 = white pawn

var board : Array
# white's turn : true, black's turn: false
var white : bool = true
# confirming the move : true, selecting the move : false
var state : bool
var moves = []
var selected_piece : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# board with the pieces
	board.append([4,2,3,5,6,3,2,4])
	board.append([1,1,1,1,1,1,1,1])
	board.append([0,0,0,0,0,0,0,0])
	board.append([0,0,0,0,0,0,0,0])
	board.append([0,0,0,0,0,0,0,0])
	board.append([0,0,0,0,0,0,0,0])
	board.append([-1,-1,-1,-1,-1,-1,-1,-1])
	board.append([-4,-2,-3,-5,-6,-3,-2,-4])
	
	display_board()

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_mouse_out(): return
			var var1 = snapped(get_global_mouse_position().x, 0) / CELL_WIDTH
			var var2 = abs(snapped(get_global_mouse_position().y, 0) / CELL_WIDTH)
			# white pieces > 0 and black pieces < 0
			if !state && (white && board[var2][var1] > 0 || !white && board[var2][var1] < 0):
				selected_piece = Vector2(var2, var1)
				show_options()
				state = true
			
func is_mouse_out():
	if get_global_mouse_position().x < 0 || get_global_mouse_position().x > 144 || get_global_mouse_position().y > 0 || get_global_mouse_position().y < -144:
			return true

func display_board():
	for i in BOARD_SIZE:
		for j in BOARD_SIZE:
			var holder = TEXTURE_HOLDER.instantiate()
			pieces.add_child(holder)
			holder.global_position = Vector2(j * CELL_WIDTH + (CELL_WIDTH/2), -i * CELL_WIDTH - (CELL_WIDTH/2))
			
			match board[i][j]:
				-6: holder.texture = BLACK_KING
				-5: holder.texture = BLACK_QUEEN
				-4: holder.texture = BLACK_ROOK
				-3: holder.texture = BLACK_BISHOP
				-2: holder.texture = BLACK_KNIGHT
				-1: holder.texture = BLACK_PAWN
				0: holder.texture = null
				6: holder.texture = WHITE_KING
				5: holder.texture = WHITE_QUEEN
				4: holder.texture = WHITE_ROOK
				3: holder.texture = WHITE_BISHOP
				2: holder.texture = WHITE_KNIGHT
				1: holder.texture = WHITE_PAWN
				
func show_options():
	moves = get_moves()
	if moves == []:
		state = false
		return
	show_dots()
	
func show_dots():
	for i in moves:
		var holder = TEXTURE_HOLDER.instantiate()
		dots.add_child(holder)
		holder.texture = PIECE_MOVE
		holder.global_position = Vector2(i.y * CELL_WIDTH + (CELL_WIDTH/2), -i.y * CELL_WIDTH - (CELL_WIDTH/2))
	
func get_moves():
	match abs(board[selected_piece.x][selected_piece.y]):
		1: print("pawn")
		2: print("knight")
		3: print("bishop")
		4: print("rook")
		5: print("queen")
		6: print("king")
		
	return []
