import 'package:flutter/material.dart';
import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';
import 'package:flutter_chess/ui/chess_piece.dart';

class ChessSquare extends StatelessWidget {
  final Position position;
  final Piece? piece;
  final bool isSelected;
  final bool isCheck;
  final Move? move;
  final VoidCallback onTap;

  //0xAARRGGBB
  static const Color lightSquare = Color(0xFFeeeed2);
  static const Color darkSquare = Color(0xFF769656);
  static const Color selectedSquare = Color(0xFFf6f669);
  static const Color checkedSquareColor = Color(0xFFf9031e);

  const ChessSquare({
    super.key,
    required this.position,
    required this.piece,
    required this.isSelected,
    required this.isCheck,
    required this.move,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLight = (position.row + position.col) % 2 == 0;

    Color background = isLight ? lightSquare : darkSquare;

    if (isSelected) {
      background = selectedSquare;
    }

    if (isCheck) {
      background = checkedSquareColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(color: background),
          if (move != null) _buildMoveIndicator(),
          if (piece != null)
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.85,
                heightFactor: 0.85,
                child: ChessPiece(piece: piece!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMoveIndicator() {
    final bool isCapture = move!.capturedPiece != null;

    return Center(
      child: Container(
        width: isCapture ? 48 : 25,
        height: isCapture ? 48 : 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCapture
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.3),
          border: isCapture
              ? Border.all(color: Colors.black.withValues(alpha: 0.4), width: 4)
              : null,
        ),
      ),
    );
  }
}
