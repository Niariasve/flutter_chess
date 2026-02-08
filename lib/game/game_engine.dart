import 'package:flutter_chess/core/position.dart';
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

    // Castling
    final bool isCastling =
        movingPiece.pieceType == PieceType.king &&
        (move.to.col - move.from.col).abs() == 2;

    if (isCastling) {
      final int row = move.from.row;

      // Short castling
      if (move.to.col == 6) {
        final Position rookFrom = Position(row: row, col: 7);
        final Position rookTo = Position(row: row, col: 5);

        final Piece? rook = state.board.pieceAt(rookFrom);
        state.board.setPiece(rookTo, rook);
        state.board.setPiece(rookFrom, null);
        rook!.hasMoved = true;
      }

      // Long castling
      if (move.to.col == 2) {
        final Position rookFrom = Position(row: row, col: 0);
        final Position rookTo = Position(row: row, col: 3);

        final Piece? rook = state.board.pieceAt(rookFrom);
        state.board.setPiece(rookTo, rook);
        state.board.setPiece(rookFrom, null);
        rook!.hasMoved = true;
      }
    }

    state.board.setPiece(move.to, movingPiece);
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

    // Castling
    if (movingPiece.pieceType == PieceType.king &&
        (lastMove.to.col - lastMove.from.col).abs() == 2) {
      final int row = lastMove.from.row;

      // Short castling
      if (lastMove.to.col == 6) {
        final Position rookFrom = Position(row: row, col: 5);
        final Position rookTo = Position(row: row, col: 7);

        final Piece? rook = state.board.pieceAt(rookFrom);
        state.board.setPiece(rookTo, rook);
        state.board.setPiece(rookFrom, null);
        rook!.hasMoved = false;
      }

      // Long castling
      if (lastMove.to.col == 2) {
        final Position rookFrom = Position(row: row, col: 3);
        final Position rookTo = Position(row: row, col: 0);

        final Piece? rook = state.board.pieceAt(rookFrom);
        state.board.setPiece(rookTo, rook);
        state.board.setPiece(rookFrom, null);
        rook!.hasMoved = false;
      }
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
