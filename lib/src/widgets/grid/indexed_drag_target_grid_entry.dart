import 'dart:math';

import 'package:flutter/widgets.dart';

final class IndexedDragTargetGridEntry {
  const IndexedDragTargetGridEntry({required this.point, required this.child});

  final Point point;
  final Widget child;
}
