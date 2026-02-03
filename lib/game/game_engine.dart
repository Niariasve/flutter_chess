import 'package:flutter_chess/models/game_state.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

class GameEngine {
  void applyMove(GameState state, Move move) {
    final Piece? movingPiece = state.board.pieceAt(move.from);

    if (movingPiece == null) {
      throw Exception('No piece at source position');
    }

    final Piece? capturedPiece = state.board.pieceAt(move.to);

    state.board.setPiece(move.from, null);

    movingPiece.hasMoved = true;

    state.moveHistory.add(
      Move(
        from: move.from,
        to: move.to,
        capturedPiece: capturedPiece,
        promotion: move.promotion,
      ),
    );

    state.turn = state.turn == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;
  }

  void undoMove(GameState state) {
    if (state.moveHistory.isEmpty) return;

    final Move lastMove = state.moveHistory.removeLast();

    final Piece? movingPiece = state.board.pieceAt(lastMove.to);
    if (movingPiece == null) {
      throw Exception('No piece to undo');
    }

    state.board.setPiece(lastMove.from, movingPiece);
    state.board.setPiece(lastMove.to, lastMove.capturedPiece);

    // TODO: Check if a piece has moved before
    movingPiece.hasMoved = false; // Simplified for now

    state.turn = state.turn == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;
  }
}
