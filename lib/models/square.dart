import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/piece.dart';

class Square {
  final Position position;
  Piece? piece;

  Square({required this.position, this.piece});

  bool get isEmpty => piece == null;

  bool get hasPiece => piece != null;
}