extends ChessRender
class_name ChessBoard

func set_move(var2, var1):
	var move_made = false
	var is_promotion = false
	var target_move = null

	for i in moves:
		if i.x == var2 && i.y == var1:
			target_move = i
			move_made = true
			break

	if move_made:
		is_animating = true
		delete_dots()

		# fetch sprites
		var moving_node = pieces.get_node_or_null("%d_%d" % [selected_piece.x, selected_piece.y])
		var captured_node = pieces.get_node_or_null("%d_%d" % [var2, var1])

		# capturing
		if captured_node and board[var2][var1] != 0:
			captured_node.texture = null 

		var secondary_moving_node = null
		var secondary_target_pos = Vector2.ZERO

		# Promotions and castlings
		match board[selected_piece.x][selected_piece.y]:
			1: 
				if target_move.x == 7: is_promotion = true
			-1:
				if target_move.x == 0: is_promotion = true
			4:
				if selected_piece.x == 0 && selected_piece.y == 0: white_rook_left = true
				elif selected_piece.x == 0 && selected_piece.y == 7: white_rook_right = true
			-4:
				if selected_piece.x == 7 && selected_piece.y == 0: black_rook_left = true
				elif selected_piece.x == 7 && selected_piece.y == 7: black_rook_right = true
			6:
				if selected_piece.x == 0 && selected_piece.y == 4:
					white_king = true
					if target_move.y == 2:
						white_rook_left = true
						white_rook_right = true
						secondary_moving_node = pieces.get_node_or_null("0_0")
						secondary_target_pos = Vector2(3 * CELL_WIDTH + (CELL_WIDTH/2), -0 * CELL_WIDTH - (CELL_WIDTH/2))
						board[0][0] = 0
						board[0][3] = 4
					elif target_move.y == 6:
						white_rook_left = true
						white_rook_right = true
						secondary_moving_node = pieces.get_node_or_null("0_7")
						secondary_target_pos = Vector2(5 * CELL_WIDTH + (CELL_WIDTH/2), -0 * CELL_WIDTH - (CELL_WIDTH/2))
						board[0][7] = 0
						board[0][5] = 4
				white_king_pos = target_move
			-6:
				if selected_piece.x == 7 && selected_piece.y == 4:
					black_king = true
					if target_move.y == 2:
						black_rook_left = true
						black_rook_right = true
						secondary_moving_node = pieces.get_node_or_null("7_0")
						secondary_target_pos = Vector2(3 * CELL_WIDTH + (CELL_WIDTH/2), -7 * CELL_WIDTH - (CELL_WIDTH/2))
						board[7][0] = 0
						board[7][3] = -4
					elif target_move.y == 6:
						black_rook_left = true
						black_rook_right = true
						secondary_moving_node = pieces.get_node_or_null("7_7")
						secondary_target_pos = Vector2(5 * CELL_WIDTH + (CELL_WIDTH/2), -7 * CELL_WIDTH - (CELL_WIDTH/2))
						board[7][7] = 0
						board[7][5] = -4
				black_king_pos = target_move

		# animation with tweens
		var target_pos = Vector2(var1 * CELL_WIDTH + (CELL_WIDTH/2), -var2 * CELL_WIDTH - (CELL_WIDTH/2))
		
		var tween = create_tween()
		tween.set_parallel(true) # parallel animations (castling)
		
		if moving_node:
			# transition
			tween.tween_property(moving_node, "global_position", target_pos, 0.25).set_trans(Tween.TRANS_SINE)
		if secondary_moving_node:
			tween.tween_property(secondary_moving_node, "global_position", secondary_target_pos, 0.25).set_trans(Tween.TRANS_SINE)
		
		# prevent errors
		if moving_node or secondary_moving_node:
			await tween.finished # finished animation
		else:
			tween.kill()

		board[var2][var1] = board[selected_piece.x][selected_piece.y]
		board[selected_piece.x][selected_piece.y] = 0
		
		# switch turns
		white = !white
		display_board()
		
		if is_promotion: 
			promote(target_move)

		is_animating = false
		state = false

		if is_stalemate():
			if white && is_in_check(white_king_pos) || !white && is_in_check(black_king_pos):
				print("CHECKMATE")
			else:
				print("DRAW")
	else:
		delete_dots()
		state = false
		if (selected_piece.x != var2 || selected_piece.y != var1) && (white && board[var2][var1] > 0 || !white && board[var2][var1] < 0):
			selected_piece = Vector2(var2, var1)
			show_options()
			state = true

func promote(_var: Vector2):
	promotion_square = _var
	white_pieces.visible = white
	black_pieces.visible = !white

func _on_button_pressed(button):
	var num_char = int(button.name.substr(0,1))
	board[promotion_square.x][promotion_square.y] = -num_char if white else num_char
	white_pieces.visible = false
	black_pieces.visible = false
	promotion_square = null
	display_board()
