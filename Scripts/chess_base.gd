extends Sprite2D
class_name ChessBase

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
@onready var white_pieces: Control = $"../CanvasLayer/white_pieces"
@onready var black_pieces: Control = $"../CanvasLayer/black_pieces"

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
var is_animating : bool = false
var moves = []
var selected_piece : Vector2

var promotion_square = null

# check if they had done their first move yet
var white_king = false
var black_king = false
var white_rook_left = false 
var white_rook_right = false 
var black_rook_left = false 
var black_rook_right = false

# variables for check:
# starting king's position
var white_king_pos = Vector2(0,4)
var black_king_pos = Vector2(7,4)

# templates
func display_board():
	pass

func show_options():
	pass

func set_move(_var2, _var1):
	pass

func _on_button_pressed(_button):
	pass
