class Position {
  final int row;
  final int col;

  Position({required this.row, required this.col});

  bool get isValid => row >= 0 && row < 8 && col >= 0 && col < 8;

  @override
  bool operator ==(Object other) =>
    other is Position &&
    other.runtimeType == runtimeType &&
    other.row == row &&
    other.col == col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() {
    return "{$row, $col}";
  }
}