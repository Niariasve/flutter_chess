import 'package:flutter/material.dart';
import 'package:flutter_chess/models/piece.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChessPiece extends StatelessWidget {
  final Piece piece;

  const ChessPiece({super.key, required this.piece});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath(),
      fit: BoxFit.contain,
    );
  }

  String _assetPath() {
    final color = piece.pieceColor == PieceColor.white ? 'white' : 'black';

    switch (piece.pieceType) {
      case PieceType.king:
        return 'assets/pieces/${color}_king.svg';
      case PieceType.queen:
        return 'assets/pieces/${color}_queen.svg';
      case PieceType.rook:
        return 'assets/pieces/${color}_rook.svg';
      case PieceType.bishop:
        return 'assets/pieces/${color}_bishop.svg';
      case PieceType.knight:
        return 'assets/pieces/${color}_knight.svg';
      case PieceType.pawn:
        return 'assets/pieces/${color}_pawn.svg';
    }
  }
}
