import 'package:flutter/widgets.dart';

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
