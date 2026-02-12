import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/game/move_generator.dart';
import 'package:flutter_chess/game/move_validator.dart';
import 'package:flutter_chess/models/board.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

class GameState {
  final Board board = Board();
  PieceColor turn;
  final List<Move> moveHistory = [];

  GameState({this.turn = PieceColor.white}) {
    setUpInitialPosition();
  }

  void setUpInitialPosition() {
    _setUpPawns();
    _setupBackRank(PieceColor.white);
    _setupBackRank(PieceColor.black);
  }

  void _setUpPawns() {
    for (int col = 0; col < 8; col++) {
      board.setPiece(
        Position(row: 6, col: col),
        Piece(pieceType: PieceType.pawn, pieceColor: PieceColor.white),
      );
    }

    for (int col = 0; col < 8; col++) {
      board.setPiece(
        Position(row: 1, col: col),
        Piece(pieceType: PieceType.pawn, pieceColor: PieceColor.black),
      );
    }
  }

  void _setupBackRank(PieceColor color) {
    final int row = color == PieceColor.white ? 7 : 0;

    board.setPiece(
      Position(row: row, col: 0),
      Piece(pieceType: PieceType.rook, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 1),
      Piece(pieceType: PieceType.knight, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 2),
      Piece(pieceType: PieceType.bishop, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 3),
      Piece(pieceType: PieceType.queen, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 4),
      Piece(pieceType: PieceType.king, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 5),
      Piece(pieceType: PieceType.bishop, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 6),
      Piece(pieceType: PieceType.knight, pieceColor: color),
    );
    board.setPiece(
      Position(row: row, col: 7),
      Piece(pieceType: PieceType.rook, pieceColor: color),
    );
  }

  PieceColor oppositeColor(PieceColor color) {
    return color == PieceColor.white ? PieceColor.black : PieceColor.white;
  }

  bool isInCheck(PieceColor color) {
    final generator = MoveGenerator();

    Position? kingPosition = findKingPosition(color);

    // King position not found
    if (kingPosition == null) return false;

    final PieceColor enemy = color == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    final PieceColor originalTurn = turn;
    turn = enemy;

    final enemyMoves = generator.generateMoves(this);

    turn = originalTurn;

    for (final move in enemyMoves) {
      if (move.to == kingPosition) return true;
    }

    return false;
  }

  Position? findKingPosition(PieceColor color) {
    for (final row in board.squares) {
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

  bool isCheckmate(GameState state, PieceColor color) {
    if (!state.isInCheck(color)) return false;

    final PieceColor originalTurn = state.turn;
    state.turn = color;

    final legalMoves = MoveValidator.getLegalMoves(state);

    state.turn = originalTurn;

    return legalMoves.isEmpty;
  }

  Position? checkedKingPosition() {
    if (!isInCheck(turn)) return null;

    return findKingPosition(turn);
  }
}
