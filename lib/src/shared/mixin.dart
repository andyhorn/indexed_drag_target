import 'dart:math';

import 'package:flutter/widgets.dart';

mixin DragTargetUtilityMixin<T extends StatefulWidget> on State<T> {
  List<GlobalKey> get keys;

  Iterable<GlobalKey> generateKeys(int numKeys) {
    return List<GlobalKey>.generate(numKeys, (_) => GlobalKey());
  }

  int getIndicatorIndex(Offset position) {
    final distances = [
      for (var i = 0; i < keys.length; i++) ...[
        (index: i, distance: _getDistanceToIndicator(position, keys[i])),
      ],
    ];

    final nearestIndicator = distances.reduce(
      (a, b) => a.distance < b.distance ? a : b,
    );

    return nearestIndicator.index;
  }

  double _getDistanceToIndicator(Offset offset, GlobalKey key) {
    final keyPosition = _getPosition(key);

    if (keyPosition == null) {
      return double.infinity;
    }

    final distance = _getDistance(
      x1: offset.dx,
      x2: keyPosition.dx,
      y1: offset.dy,
      y2: keyPosition.dy,
    );

    return distance;
  }

  Offset? _getPosition(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;

    if (box == null) {
      return null;
    }

    final position = box.localToGlobal(Offset.zero);
    return position;
  }

  double _getDistance({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
  }) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
}
