import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:indexed_drag_target/src/shared/constants.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';
import 'package:indexed_drag_target/src/widgets/grid/grid.dart';

class IndexedDragTargetGrid<T extends Object> extends StatefulWidget {
  const IndexedDragTargetGrid({
    super.key,
    required this.children,
    required this.columns,
    this.indicatorBuilder = defaultIndicatorBuilder,
    required this.onAccept,
    this.onWillAccept,
    required this.rows,
  });

  final List<IndexedDragTargetGridEntry> children;
  final int columns;
  final IndicatorBuilder indicatorBuilder;
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
              final index = widget.children.indexWhere((entry) {
                final gridIndex = getGridIndex(
                  column: entry.point.x.toInt(),
                  row: entry.point.y.toInt(),
                  width: widget.columns,
                );

                return gridIndex == i;
              });

              if (index != -1) {
                return widget.children[index].child;
              }

              if (this.index == i) {
                final point = getCoordinateFromIndex(i);
                return widget.indicatorBuilder(context, point);
              }

              return const SizedBox.shrink();
            },
            onMove: (details) {
              final data = details.data;
              final point = getCoordinateFromIndex(i);

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
                final point = getCoordinateFromIndex(i);

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

  Point getCoordinateFromIndex(int index) {
    return Point(index % widget.columns, index ~/ widget.columns);
  }

  void setIndex(int? index) {
    debounce.run(() => setState(() => this.index = index));
  }
}
