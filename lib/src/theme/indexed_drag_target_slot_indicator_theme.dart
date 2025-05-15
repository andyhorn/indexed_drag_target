import 'package:flutter/widgets.dart';

final class IndexedDragTargetSlotIndicatorTheme extends InheritedWidget {
  const IndexedDragTargetSlotIndicatorTheme({
    super.key,
    required super.child,
    this.color,
    this.borderRadius,
    this.border,
  });

  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  static IndexedDragTargetSlotIndicatorTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          IndexedDragTargetSlotIndicatorTheme
        >();
  }

  @override
  bool updateShouldNotify(
    covariant IndexedDragTargetSlotIndicatorTheme oldWidget,
  ) {
    return oldWidget.color != color;
  }
}
