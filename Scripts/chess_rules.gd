extends ChessInput
class_name ChessRules

func get_moves():
	var _moves = []
	match abs(board[selected_piece.x][selected_piece.y]):
		1: _moves = get_pawn_moves()
		2: _moves = get_knight_moves()
		3: _moves = get_bishop_moves()
		4: _moves = get_rook_moves()
		5: _moves = get_queen_moves()
		6: _moves = get_king_moves()
		
	return _moves

func get_rook_moves():
	var _moves = []
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	
	for i in directions:
		var pos = selected_piece
		pos += i
		while is_valid_position(pos):
			if is_empty(pos): _moves.append(pos)
			elif is_enemy(pos): 
				_moves.append(pos)
				break
			else: break
			
			pos += i
	
	return _moves
	
func get_bishop_moves():
	var _moves = []
	var directions = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	
	for i in directions:
		var pos = selected_piece
		pos += i
		while is_valid_position(pos):
			if is_empty(pos): _moves.append(pos)
			elif is_enemy(pos): 
				_moves.append(pos)
				break
			else: break
			
			pos += i
	
	return _moves
	
func get_queen_moves():
	var _moves = []
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	
	for i in directions:
		var pos = selected_piece
		pos += i
		while is_valid_position(pos):
			if is_empty(pos): _moves.append(pos)
			elif is_enemy(pos): 
				_moves.append(pos)
				break
			else: break
			
			pos += i
	
	return _moves
	
func get_king_moves():
	var _moves = []
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	
	for i in directions:
		var pos = selected_piece + i
		if is_valid_position(pos):
			if is_empty(pos): _moves.append(pos)
			elif is_enemy(pos): 
				_moves.append(pos)
				
	if white && !white_king:
		if !white_rook_left && is_empty(Vector2(0,1)) && is_empty(Vector2(0,2)) && is_empty(Vector2(0,3)):
			_moves.append(Vector2(0,2))
		if !white_rook_right && is_empty(Vector2(0,5)) && is_empty(Vector2(0,6)):
			_moves.append(Vector2(0,6))
	elif !white && !black_king:
		if !black_rook_left && is_empty(Vector2(7,1)) && is_empty(Vector2(7,2)) && is_empty(Vector2(7,3)):
			_moves.append(Vector2(7,2))
		if !black_rook_right && is_empty(Vector2(7,5)) && is_empty(Vector2(7,6)):
			_moves.append(Vector2(7,6))
	
	return _moves
	
func get_knight_moves():
	var _moves = []
	var directions = [Vector2(2,1),Vector2(2,-1),Vector2(1,2),Vector2(1,-2),Vector2(-2,1),Vector2(-2,-1),Vector2(-1,2),Vector2(-1,-2)]
	
	for i in directions:
		var pos = selected_piece + i
		if is_valid_position(pos):
			if is_empty(pos): _moves.append(pos)
			elif is_enemy(pos): 
				_moves.append(pos)
	
	return _moves
	
func get_pawn_moves():
	var _moves = []
	var direction
	var is_first_move = false
	
	if white: direction = Vector2(1,0)
	else: direction = Vector2(-1,0)
	
	if white && selected_piece.x == 1 || !white && selected_piece.x == 6:
		is_first_move = true
		
	var pos = selected_piece + direction
	if is_empty(pos): _moves.append(pos)
	
	# for taking a piece
	pos = selected_piece + Vector2(direction.x, 1)
	if is_valid_position(pos):
		if is_enemy(pos): _moves.append(pos)
	pos = selected_piece + Vector2(direction.x, -1)
	if is_valid_position(pos):
		if is_enemy(pos): _moves.append(pos)
		
	pos = selected_piece + direction * 2
	if is_first_move && is_empty(pos) && is_empty(selected_piece + direction): _moves.append(pos)
	
	return _moves
	
func is_valid_position(pos: Vector2):
	if pos.x >= 0 && pos.x < BOARD_SIZE && pos.y >= 0 && pos.y < BOARD_SIZE: return true
	return false
	
func is_empty(pos : Vector2):
	if board[pos.x][pos.y] == 0: return true
	return false
	
func is_enemy(pos : Vector2):
	# on white's turn, the enemy position is a negative index
	# on black's turn is positive
	if white && board[pos.x][pos.y] < 0 || !white && board[pos.x][pos.y] > 0: return true
	return false

func is_in_check(king_pos: Vector2):
	var directions = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	
	var pawn_direction = 1 if white else -1
	var pawn_attacks = [
		king_pos + Vector2(pawn_direction, 1),
		king_pos + Vector2(pawn_direction, -1)
	]
