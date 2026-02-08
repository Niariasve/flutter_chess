import 'package:flutter/material.dart';
import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/piece.dart';
import 'package:flutter_chess/ui/chess_piece.dart';

class ChessSquare extends StatelessWidget {
  final Position position;
  final Piece? piece;
  final bool isSelected;
  final bool isLegalTarget;
  final VoidCallback onTap;

  const ChessSquare({
    super.key,
    required this.position,
    required this.piece,
    required this.isSelected,
    required this.isLegalTarget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLight = (position.row + position.col) % 2 == 0;
    Color color = isLight ? Colors.brown[200]! : Colors.brown[600]!;

    if (isSelected) {
      color = Colors.yellow;
    } else if (isLegalTarget) {
      color = Colors.green;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        child: piece != null ? Center(child: ChessPiece(piece: piece!)) : null,
      ),
    );
  }
}
