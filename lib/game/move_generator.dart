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

        if (piece.pieceType == PieceType.knight) {
          _generateKnightMoves(state, square.position, piece, moves);
        }

        if (piece.pieceType == PieceType.bishop) {
          _generateBishopMoves(state, square.position, piece, moves);
        }

        if (piece.pieceType == PieceType.rook) {
          _generateRookMoves(state, square.position, piece, moves);
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

  void _generateKnightMoves(
    GameState state,
    Position from,
    Piece knight,
    List<Move> moves,
  ) {
    final List<int> dRow = [2, 2, -2, -2, -1, 1, -1, 1];
    final List<int> dCol = [-1, 1, -1, 1, 2, 2, -2, -2];

    Piece? targetPiece;

    for (int i = 0; i < 8; i++) {
      final Position position = Position(
        row: from.row + dRow[i],
        col: from.col + dCol[i],
      );

      if (!position.isValid) continue;

      targetPiece = state.board.pieceAt(position);

      if (targetPiece == null) {
        moves.add(Move(from: from, to: position));
        continue;
      }

      if (targetPiece.pieceColor != knight.pieceColor) {
        moves.add(Move(from: from, to: position, capturedPiece: targetPiece));
      }
    }
  }

  void _generateBishopMoves(
    GameState state,
    Position from,
    Piece bishop,
    List<Move> moves,
  ) {
    final List<int> dRow = [-1, -1, 1, 1];
    final List<int> dCol = [-1, 1, -1, 1];

    for (int i = 0; i < 4; i++) {
      int c = 1;

      while (true) {
        final Position position = Position(
          row: from.row + (c * dRow[i]),
          col: from.col + (c * dCol[i]),
        );

        if (!position.isValid) break;

        final Piece? targetPiece = state.board.pieceAt(position);

        if (targetPiece == null) {
          moves.add(Move(from: from, to: position));
          c++;
          continue;
        }

        if (targetPiece.pieceColor != bishop.pieceColor) {
          moves.add(Move(from: from, to: position, capturedPiece: targetPiece));
        }

        break;
      }
    }
  }

  void _generateRookMoves(
    GameState state,
    Position from,
    Piece rook,
    List<Move> moves,
  ) {
    final List<int> dRow = [-1, 0, 1, 0];
    final List<int> dCol = [0, 1, 0, -1];

    for (int i = 0; i < 4; i++) {
      int c = 1;

      while (true) {
        final Position position = Position(
          row: from.row + (c * dRow[i]),
          col: from.col + (c * dCol[i]),
        );

        if (!position.isValid) break;

        final Piece? targetPiece = state.board.pieceAt(position);

        if (targetPiece == null) {
          moves.add(Move(from: from, to: position));
          c++;
          continue;
        }

        if (targetPiece.pieceColor != rook.pieceColor) {
          moves.add(Move(from: from, to: position, capturedPiece: targetPiece));
        }

        break;
      }
    }
  }
}
