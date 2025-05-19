import 'package:flutter/widgets.dart';

final class IndexedDragTargetGridCellTheme extends InheritedWidget {
  const IndexedDragTargetGridCellTheme({
    super.key,
    required super.child,
    this.border,
    this.borderRadius,
    this.background,
  });

  static IndexedDragTargetGridCellTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IndexedDragTargetGridCellTheme>();
  }

  final TableBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Color? background;

  @override
  bool updateShouldNotify(covariant IndexedDragTargetGridCellTheme oldWidget) {
    return oldWidget.border != border ||
        oldWidget.background != background ||
        oldWidget.borderRadius != borderRadius;
  }
}
