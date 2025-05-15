import 'package:flutter/widgets.dart';
import 'package:indexed_drag_target/src/indexed_drag_target_flex.dart';

class IndexedDragTargetColumn<T extends Object>
    extends IndexedDragTargetFlex<T> {
  const IndexedDragTargetColumn({
    super.key,
    required super.onAccept,
    required super.children,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.mainAxisSize = MainAxisSize.max,
    super.crossAxisAlignment = CrossAxisAlignment.stretch,
    super.onWillAccept,
    super.spacing,
    super.clipBehavior,
    super.textBaseline,
    super.textDirection,
    super.verticalDirection,
  }) : super(direction: Axis.vertical);
}
