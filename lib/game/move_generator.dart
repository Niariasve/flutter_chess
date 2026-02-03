import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/game_state.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

class MoveGenerator {
  List<Move> generateMoves(GameState state) {
    final List<Move> moves = [];

    for (final row in state.board.squares) {
      for (final square in row) {
        final piece = square.piece;

        if (piece == null || piece.pieceColor != state.turn) continue;

        if (piece.pieceType == PieceType.pawn) {
          _generatePawnMoves(state, square.position, piece, moves);
        }
      }
    }

    return moves;
  }

  void _generatePawnMoves(
    GameState state,
    Position from,
    Piece pawn,
    List<Move> moves,
  ) {
    final int direction = pawn.pieceColor == PieceColor.white ? -1 : 1;

    final Position forward = Position(row: from.row + direction, col: from.col);
    if (!forward.isValid) return;

    if (state.board.pieceAt(forward) == null) {
      moves.add(Move(from: from, to: forward));
    }

    final int startRow = pawn.pieceColor == PieceColor.white ? 6 : 1;
    if (from.row == startRow) {
      final Position twoForward = Position(
        row: from.row + (2 * direction),
        col: from.col,
      );

      if (twoForward.isValid &&
          state.board.pieceAt(forward) == null &&
          state.board.pieceAt(twoForward) == null) {
        moves.add(Move(from: from, to: twoForward));
      }
    }

    for (final int colOffset in [-1, 1]) {
      final Position diagonal = Position(
        row: from.row + direction,
        col: from.col + colOffset,
      );

      if (!diagonal.isValid) continue;

      final Piece? targetPiece = state.board.pieceAt(diagonal);

      if (targetPiece != null && targetPiece.pieceColor != pawn.pieceColor) {
        moves.add(Move(from: from, to: diagonal, capturedPiece: targetPiece));
      }
    }

    if (state.moveHistory.isNotEmpty) {
      final Move lastMove = state.moveHistory.last;

      final Piece? lastMovedPiece = state.board.pieceAt(lastMove.to);

      if (lastMovedPiece != null &&
          lastMovedPiece.pieceType == PieceType.pawn &&
          (lastMove.from.row - lastMove.to.row).abs() == 2) {
        final bool correctRow = pawn.pieceColor == PieceColor.white
            ? from.row == 3
            : from.row == 4;

        if (correctRow && (lastMove.to.col - from.col).abs() == 1) {
          final Position enPassantTarget = Position(
            row: from.row + direction,
            col: lastMove.to.col,
          );

          if (enPassantTarget.isValid &&
              state.board.pieceAt(enPassantTarget) == null) {
            moves.add(
              Move(
                from: from,
                to: enPassantTarget,
                capturedPiece: lastMovedPiece,
              ),
            );
          }
        }
      }
    }
  }
}
