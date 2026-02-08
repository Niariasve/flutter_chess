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

      if (isInCheck(state, kingColor)) {
        return false;
      }

      final int direction = move.to.col > move.from.col ? 1 : -1;

      final Position intermediate = Position(
        row: move.from.row,
        col: move.from.col + direction,
      );

      engine.applyMove(state, Move(from: move.from, to: intermediate));

      final bool inCheckIntermediate = isInCheck(state, kingColor);

      engine.undoMove(state);

      if (inCheckIntermediate) {
        return false;
      }
    }

    engine.applyMove(state, move);

    final PieceColor movedColor = state.turn == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    Position? kingPosition = _findKingPosition(state, movedColor);

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

  static bool isInCheck(GameState state, PieceColor color) {
    final generator = MoveGenerator();

    Position? kingPosition = _findKingPosition(state, color);

    // King position not found
    if (kingPosition == null) return false;

    final PieceColor enemy = color == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    final PieceColor originalTurn = state.turn;
    state.turn = enemy;

    final enemyMoves = generator.generateMoves(state);

    state.turn = originalTurn;

    for (final move in enemyMoves) {
      if (move.to == kingPosition) return true;
    }

    return false;
  }

  static bool isCheckmate(GameState state, PieceColor color) {
    if (!isInCheck(state, color)) return false;

    final PieceColor originalTurn = state.turn;
    state.turn = color;

    final legalMoves = MoveValidator.getLegalMoves(state);

    state.turn = originalTurn;

    return legalMoves.isEmpty;
  }

  static Position? _findKingPosition(GameState state, PieceColor color) {
    for (final row in state.board.squares) {
      for (final square in row) {
        final Piece? piece = square.piece;

        if (piece != null &&
            piece.pieceType == PieceType.king &&
            piece.pieceColor == color) {
          return square.position;
        }
      }
    }
    return null;
  }
}
