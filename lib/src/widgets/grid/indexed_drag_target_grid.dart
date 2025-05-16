import 'dart:math' show Point;

import 'package:flutter/gestures.dart';
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
    this.childAspectRatio = 1.0,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.crossAxisSpacing = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.mainAxisSpacing = 0.0,
    this.padding,
    this.physics,
    this.primary,
    this.restorationId,
    this.scrollDirection = Axis.vertical,
    this.semanticChildCount,
    this.shrinkWrap = false,
  });

  final List<IndexedDragTargetGridEntry> children;
  final int columns;
  final IndicatorBuilder indicatorBuilder;
  final OnAcceptPointCallback<T> onAccept;
  final OnWillAcceptPointCallback<T>? onWillAccept;
  final int rows;
  final double childAspectRatio;
  final Clip clipBehavior;
  final ScrollController? controller;
  final double crossAxisSpacing;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior hitTestBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool? primary;
  final String? restorationId;
  final Axis scrollDirection;
  final int? semanticChildCount;
  final bool shrinkWrap;

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
      childAspectRatio: widget.childAspectRatio,
      clipBehavior: widget.clipBehavior,
      controller: widget.controller,
      crossAxisCount: widget.columns,
      crossAxisSpacing: widget.crossAxisSpacing,
      dragStartBehavior: widget.dragStartBehavior,
      hitTestBehavior: widget.hitTestBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      mainAxisSpacing: widget.mainAxisSpacing,
      padding: widget.padding,
      physics: widget.physics,
      primary: widget.primary,
      restorationId: widget.restorationId,
      scrollDirection: widget.scrollDirection,
      semanticChildCount: widget.semanticChildCount,
      shrinkWrap: widget.shrinkWrap,
      children: [
        for (var i = 0; i < widget.columns * widget.rows; i++) ...[
          DragTarget<T>(
            builder: (context, candidates, rejects) {
              final index = widget.children.indexWhere((entry) {
                final arrayIndex = entry.getArrayIndex(widget.columns);
                return arrayIndex == i;
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
                setIndex(null);
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
