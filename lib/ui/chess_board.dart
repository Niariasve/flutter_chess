import 'package:flutter/material.dart';
import 'package:flutter_chess/core/position.dart';
import 'package:flutter_chess/game/game_engine.dart';
import 'package:flutter_chess/game/move_validator.dart';
import 'package:flutter_chess/models/game_state.dart';
import 'package:flutter_chess/models/move.dart';
import 'package:flutter_chess/models/piece.dart';

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

          return _buildSquare(position);
        },
      ),
    );
  }

  Widget _buildSquare(Position position) {
    final bool isLight = (position.row + position.col) % 2 == 0;

    final Piece? piece = gameState.board.pieceAt(position);

    final bool isSelected = position == selectedPosition;

    final bool isLegalTarget = legalMoves.any((m) => m.to == position);

    Color color = isLight ? Colors.brown[200]! : Colors.brown[600]!;

    if (isSelected) {
      color = Colors.yellow;
    } else if (isLegalTarget) {
      color = Colors.green;
    }

    return GestureDetector(
      onTap: () => _onSquareTap(position),
      child: Container(
        color: color,
        child: piece != null ? Center(child: _buildPiece(piece)) : null,
      ),
    );
  }

  Widget _buildPiece(Piece piece) {
    final String symbol = _pieceSymbol(piece);

    return Text(symbol, style: const TextStyle(fontSize: 32));
  }

  String _pieceSymbol(Piece piece) {
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
