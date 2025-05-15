import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';
import 'package:indexed_drag_target/src/widgets/grid/grid.dart';
import 'package:indexed_drag_target/src/widgets/indexed_drag_target_slot_indicator.dart';

class IndexedDragTargetGrid<T extends Object> extends StatefulWidget {
  const IndexedDragTargetGrid({
    super.key,
    required this.children,
    required this.columns,
    required this.onAccept,
    this.onWillAccept,
    required this.rows,
  });

  final List<IndexedDragTargetGridEntry> children;
  final int columns;
  final OnAcceptPointCallback<T> onAccept;
  final OnWillAcceptPointCallback<T>? onWillAccept;
  final int rows;

  @override
  State<IndexedDragTargetGrid<T>> createState() =>
      _IndexedDragTargetGridState<T>();
}

class _IndexedDragTargetGridState<T extends Object>
    extends State<IndexedDragTargetGrid<T>> {
  final debounce = Debounce(10);

  int? index;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.columns,
      children: [
        for (var i = 0; i < widget.columns * widget.rows; i++) ...[
          DragTarget<T>(
            builder: (context, candidates, rejects) {
              final index = widget.children.indexWhere(
                (entry) =>
                    getGridIndex(
                      column: entry.point.y.toInt(),
                      row: entry.point.x.toInt(),
                      width: widget.columns,
                    ) ==
                    i,
              );

              if (index != -1) {
                return widget.children[index].child;
              }

              return this.index == i
                  ? IndexedDragTargetSlotIndicator()
                  : const SizedBox.shrink();
            },
            onMove: (details) {
              final data = details.data;
              final row = i ~/ widget.columns;
              final column = i % widget.columns;
              final point = Point(row, column);

              if (widget.onWillAccept case final onWillAccept?) {
                if (!onWillAccept(data, point)) {
                  return;
                }
              }

              setIndex(i);
            },
            onLeave: (_) => setIndex(null),
            onAcceptWithDetails: (details) {
              final data = details.data;

              if (index == i) {
                final row = i ~/ widget.columns;
                final column = i % widget.columns;
                final point = Point(row, column);

                if (widget.onWillAccept case final onWillAccept?) {
                  if (!onWillAccept(data, point)) {
                    return;
                  }
                }

                widget.onAccept(data, point);
              }
            },
          ),
        ],
      ],
    );
  }

  void setIndex(int? index) {
    debounce.run(() => setState(() => this.index = index));
  }
}
