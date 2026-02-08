import 'package:flutter/material.dart';
import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/game/game_engine.dart';
import 'package:flutter_chess/game/move_validator.dart';
import 'package:flutter_chess/models/game_state.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';
import 'package:flutter_chess/ui/chess_square.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<StatefulWidget> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final GameState gameState = GameState();
  final GameEngine gameEngine = GameEngine();

  Position? selectedPosition;
  List<Move> legalMoves = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final int row = index ~/ 8;
          final int col = index % 8;
          final Position position = Position(row: row, col: col);
          final Move? moveToHere = legalMoves
              .where((m) => m.to == position)
              .cast<Move?>()
              .firstWhere((m) => m != null, orElse: () => null);

          return ChessSquare(
            position: position,
            piece: gameState.board.pieceAt(position),
            isSelected: position == selectedPosition,
            move: moveToHere,
            onTap: () => _onSquareTap(position),
          );
        },
      ),
    );
  }

  void _onSquareTap(Position position) {
    final Piece? tappedPiece = gameState.board.pieceAt(position);

    if (selectedPosition == null) {
      if (tappedPiece != null && tappedPiece.pieceColor == gameState.turn) {
        setState(() {
          selectedPosition = position;
          legalMoves = MoveValidator.getLegalMoves(
            gameState,
          ).where((m) => m.from == position).toList();
        });
      }

      return;
    }

    final Move? move = legalMoves
        .where((m) => m.to == position)
        .cast<Move?>()
        .firstWhere((m) => m != null, orElse: () => null);

    if (move != null) {
      setState(() {
        gameEngine.applyMove(gameState, move);
        selectedPosition = null;
        legalMoves.clear();
      });
      return;
    }

    setState(() {
      selectedPosition = null;
      legalMoves.clear();
    });
  }
}
