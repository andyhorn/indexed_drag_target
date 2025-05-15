import 'package:flutter/material.dart';

class IndexedDragTargetIndicatorTheme extends InheritedWidget {
  const IndexedDragTargetIndicatorTheme({
    super.key,
    required super.child,
    this.color,
    this.thickness,
    this.margin,
  });

  final Color? color;
  final double? thickness;
  final double? margin;

  static IndexedDragTargetIndicatorTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IndexedDragTargetIndicatorTheme>();
  }

  @override
  bool updateShouldNotify(covariant IndexedDragTargetIndicatorTheme oldWidget) {
    return oldWidget.color != color || oldWidget.thickness != thickness;
  }
}

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
