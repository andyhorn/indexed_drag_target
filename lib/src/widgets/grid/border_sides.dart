import 'package:flutter/widgets.dart';

final class BorderSides {
  const BorderSides({
    required TableBorder? border,
    required int crossAxisCount,
    required int index,
    required int length,
  }) : _border = border,
       _crossAxisCount = crossAxisCount,
       _index = index,
       _length = length;

  final TableBorder? _border;
  final int _crossAxisCount;
  final int _index;
  final int _length;

  int get _row => _index ~/ _crossAxisCount;
  int get _col => _index % _crossAxisCount;

  BorderSide get top {
    if (_border case final border?) {
      if (_row == 0) {
        return border.top;
      }

      return border.horizontalInside.scale(0.5);
    }

    return BorderSide.none;
  }

  BorderSide get bottom {
    if (_border case final border?) {
      if (_row == _length - 1) {
        return border.bottom;
      }

      return border.horizontalInside.scale(0.5);
    }

    return BorderSide.none;
  }

  BorderSide get left {
    if (_border case final border?) {
      if (_col == 0) {
        return border.left;
      }

      return border.verticalInside.scale(0.5);
    }

    return BorderSide.none;
  }

  BorderSide get right {
    if (_border case final border?) {
      if (_col == _crossAxisCount - 1) {
        return border.right;
      }

      return border.verticalInside.scale(0.5);
    }

    return BorderSide.none;
  }
}
