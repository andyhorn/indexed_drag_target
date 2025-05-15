final class RowIndices {
  const RowIndices({required this.row, required this.count});

  final int row;
  final int count;

  int firstIndicator() {
    return row * (count + 1);
  }

  int child(int j) {
    return row * count + j;
  }

  int indicator(int j) {
    return row * (count + 1) + j + 1;
  }
}
