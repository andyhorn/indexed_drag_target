import 'package:flutter/widgets.dart';

/// Determines how to display the targeting indicator if a child
/// Widget is already present.
enum IndexedDragTargetGridIndicatorStrategy {
  /// Hide/do not display an indicator if a child is present.
  hide,

  /// Display the indicator over the child.
  above,

  /// Display the indicator behind the child.
  below,
}

Widget getWidgetForIndicatorStrategy({
  required Widget? child,
  required Widget? indicator,
  required IndexedDragTargetGridIndicatorStrategy strategy,
}) {
  return switch (strategy) {
    IndexedDragTargetGridIndicatorStrategy.hide =>
      child ?? const SizedBox.shrink(),
    IndexedDragTargetGridIndicatorStrategy.above => Stack(
      children: [
        if (indicator case final indicator?) ...[indicator],
        child ?? const SizedBox.shrink(),
      ],
    ),
    IndexedDragTargetGridIndicatorStrategy.below => Stack(
      children: [
        child ?? const SizedBox.shrink(),
        if (indicator case final indicator?) ...[indicator],
      ],
    ),
  };
}
