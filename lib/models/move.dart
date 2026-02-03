import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/piece.dart';

class Move {
  final Position from;
  final Position to;
  final Piece? capturedPiece;
  final PieceType? promotion;

  Move({required this.from, required this.to, this.capturedPiece, this.promotion});
}