import 'package:flutter_chess/core/position.dart';
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
}
