import 'package:flutter_chess/models/board.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

class GameState {
  final Board board = Board();
  PieceColor turn;
  final List<Move> moveHistory = [];

  GameState({this.turn = PieceColor.white});
}