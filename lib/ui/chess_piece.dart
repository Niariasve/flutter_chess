import 'package:flutter/material.dart';
import 'package:flutter_chess/models/piece.dart';

class ChessPiece extends StatelessWidget {
  final Piece piece;

  const ChessPiece({super.key, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Text(_symbol(), style: const TextStyle(fontSize: 32));
  }

  String _symbol() {
    switch (piece.pieceType) {
      case PieceType.king:
        return piece.pieceColor == PieceColor.white ? '♔' : '♚';
      case PieceType.queen:
        return piece.pieceColor == PieceColor.white ? '♕' : '♛';
      case PieceType.rook:
        return piece.pieceColor == PieceColor.white ? '♖' : '♜';
      case PieceType.bishop:
        return piece.pieceColor == PieceColor.white ? '♗' : '♝';
      case PieceType.knight:
        return piece.pieceColor == PieceColor.white ? '♘' : '♞';
      case PieceType.pawn:
        return piece.pieceColor == PieceColor.white ? '♙' : '♟';
    }
  }
}
