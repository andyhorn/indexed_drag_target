import 'package:flutter/material.dart';

import '../theme/indexed_drag_target_slot_indicator_theme.dart';

class IndexedDragTargetSlotIndicator extends StatelessWidget {
  const IndexedDragTargetSlotIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = IndexedDragTargetSlotIndicatorTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme?.color ?? Colors.grey.shade400,
        borderRadius: theme?.borderRadius,
        border: theme?.border,
      ),
    );
  }
}
