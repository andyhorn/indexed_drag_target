import 'dart:math' show Point, pow, sqrt;

import 'package:flutter/widgets.dart';

Iterable<GlobalKey> generateKeys(int numKeys) {
  return List<GlobalKey>.generate(numKeys, (_) => GlobalKey());
}

int getNumberOfSets({required int itemCount, required int setSize}) {
  if (itemCount == 0) {
    return 0;
  }

  final fullSets = itemCount ~/ setSize;
  final remainder = itemCount % setSize;

  return fullSets + (remainder == 0 ? 0 : 1);
}

int flatten2DIndex({required int y, required int x, required width}) {
  return (y * width + x).toInt();
}

int getIndexOfClosestKey(List<GlobalKey> keys, Offset offset) {
  final distances = [
    for (var i = 0; i < keys.length; i++) ...[
      (index: i, distance: _getDistanceToKey(offset, keys[i])),
    ],
  ];

  final nearestIndicator = distances.reduce(
    (a, b) => a.distance < b.distance ? a : b,
  );

  return nearestIndicator.index;
}

double _getDistanceToKey(Offset offset, GlobalKey key) {
  final keyPosition = _getPositionOfKey(key);

  if (keyPosition == null) {
    return double.infinity;
  }

  final distance = _calculateDistance(
    _offsetToPoint(offset),
    _offsetToPoint(keyPosition),
  );

  return distance;
}

Offset? _getPositionOfKey(GlobalKey key) {
  final box = key.currentContext?.findRenderObject() as RenderBox?;

  if (box == null) {
    return null;
  }

  final offset = box.localToGlobal(Offset.zero);
  return offset;
}

Point _offsetToPoint(Offset offset) {
  return Point(offset.dx, offset.dy);
}

double _calculateDistance(Point a, Point b) {
  return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
}
