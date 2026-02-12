import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/game/game_engine.dart';
import 'package:flutter_chess/game/move_generator.dart';
import 'package:flutter_chess/models/game_state.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

class MoveValidator {
  static bool isLegalMove(GameState state, Move move) {
    GameEngine engine = GameEngine();
    MoveGenerator generator = MoveGenerator();

    final Piece? piece = state.board.pieceAt(move.from);

    final bool isCastling =
        piece != null &&
        piece.pieceType == PieceType.king &&
        (move.to.col - move.from.col).abs() == 2;

    if (isCastling) {
      final PieceColor kingColor = piece.pieceColor;

      if (state.isInCheck(kingColor)) {
        return false;
      }

      final int direction = move.to.col > move.from.col ? 1 : -1;

      final Position intermediate = Position(
        row: move.from.row,
        col: move.from.col + direction,
      );

      engine.applyMove(state, Move(from: move.from, to: intermediate));

      final bool inCheckIntermediate = state.isInCheck(kingColor);

      engine.undoMove(state);

      if (inCheckIntermediate) {
        return false;
      }
    }

    engine.applyMove(state, move);

    final PieceColor movedColor = state.turn == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    Position? kingPosition = state.findKingPosition(movedColor);

    // King position not found
    if (kingPosition == null) {
      engine.undoMove(state);
      return false;
    }

    final List<Move> enemyMoves = generator.generateMoves(state);

    for (final Move enemyMove in enemyMoves) {
      if (enemyMove.to == kingPosition) {
        engine.undoMove(state);
        return false;
      }
    }

    engine.undoMove(state);
    return true;
  }

  static List<Move> getLegalMoves(GameState state) {
    final generator = MoveGenerator();
    final List<Move> legalMoves = [];

    final List<Move> moves = generator.generateMoves(state);

    for (final move in moves) {
      if (isLegalMove(state, move)) {
        legalMoves.add(move);
      }
    }

    return legalMoves;
  }
}
