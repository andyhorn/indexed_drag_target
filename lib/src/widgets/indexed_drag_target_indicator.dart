import 'package:flutter/material.dart';
import 'package:indexed_drag_target/src/theme/theme.dart';

class IndexedDragTargetIndicator extends StatelessWidget {
  const IndexedDragTargetIndicator({
    required super.key,
    required this.visible,
    this.direction = Axis.vertical,
  });

  final bool visible;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final theme = IndexedDragTargetIndicatorTheme.of(context);

    return Visibility(
      visible: visible,
      child: Container(
        width: switch (direction) {
          Axis.vertical => null,
          Axis.horizontal => theme?.thickness ?? 2,
        },
        height: switch (direction) {
          Axis.vertical => theme?.thickness ?? 2,
          Axis.horizontal => null,
        },
        color: theme?.color ?? Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: theme?.margin ?? 4.0),
      ),
    );
  }
}
