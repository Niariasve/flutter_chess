enum PieceType { pawn, bishop, knight, rook, queen, king }

enum PieceColor { black, white }

class Piece {
  final PieceType pieceType;
  final PieceColor pieceColor;
  bool hasMoved;

  Piece({required this.pieceType, required this.pieceColor, this.hasMoved = false});
}