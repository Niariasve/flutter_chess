import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/piece.dart';
import 'package:flutter_chess/models/square.dart';

class Board {
  final List<List<Square>> squares = [];

  static const int _rowNum = 8;
  static const int _colNum = 8;

  Board() {
    for (int row = 0; row < _rowNum; row++) {
      List<Square> squareRow = [];
      for (int col = 0; col < _colNum; col++ ) {
        squareRow.add(Square(position: Position(row: row, col: col)));
      } 
      squares.add(squareRow);
    }
  }

  Square squareAt(Position position) {
    return squares[position.row][position.col];
  }

  Piece? pieceAt(Position position) {
    return squareAt(position).piece;
  }

  void setPiece(Position position, Piece? piece) {
    squareAt(position).piece = piece;
  }
}