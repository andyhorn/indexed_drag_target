import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indexed_drag_target/indexed_drag_target.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';
import 'package:indexed_drag_target/src/widgets/grid/border_sides.dart';
import 'package:indexed_drag_target/src/widgets/grid/indexed_drag_target_grid_indicator_strategy.dart';

class IndexedDragTargetGrid<T extends Object> extends StatefulWidget {
  const IndexedDragTargetGrid({
    super.key,
    required this.children,
    this.indicatorBuilder,
    this.indicatorStrategy = IndexedDragTargetGridIndicatorStrategy.hide,
    required this.crossAxisCount,
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

  final List<Widget?> children;
  final IndicatorBuilder? indicatorBuilder;
  final IndexedDragTargetGridIndicatorStrategy indicatorStrategy;
  final int crossAxisCount;
  final OnAcceptCallback<T> onAccept;
  final OnWillAcceptCallback<T>? onWillAccept;
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
    final theme = IndexedDragTargetGridCellTheme.maybeOf(context);

    return GridView.count(
      childAspectRatio: widget.childAspectRatio,
      clipBehavior: widget.clipBehavior,
      controller: widget.controller,
      crossAxisCount: widget.crossAxisCount,
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
        for (var i = 0; i < widget.crossAxisCount * widget.rows; i++) ...[
          Builder(
            builder: (context) {
              final target = _Target<T>(
                hoverBuilder:
                    (context) => widget.indicatorBuilder?.call(context, i),
                indicatorStrategy: widget.indicatorStrategy,
                onAccept: (data) {
                  widget.onAccept(data, i);
                  setIndex(null);
                },
                onLeave: () => setIndex(null),
                onMove: () => setIndex(i),
                onWillAccept: (data) => widget.onWillAccept?.call(data, i),
                targeted: index == i,
                child: widget.children[i],
              );

              final borders = BorderSides(
                border: theme?.border,
                crossAxisCount: widget.crossAxisCount,
                index: i,
                length: widget.rows,
              );

              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: borders.bottom,
                    left: borders.left,
                    top: borders.top,
                    right: borders.right,
                  ),
                  borderRadius: theme?.borderRadius,
                  color: theme?.background,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    borders.left.width,
                    borders.top.width,
                    borders.right.width,
                    borders.bottom.width,
                  ),
                  child: target,
                ),
              );
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

class _Target<T extends Object> extends StatelessWidget {
  const _Target({
    super.key,
    required this.child,
    required this.targeted,
    required this.hoverBuilder,
    required this.indicatorStrategy,
    required this.onAccept,
    required this.onLeave,
    required this.onMove,
    required this.onWillAccept,
  });

  final Widget? child;
  final bool targeted;
  final Widget? Function(BuildContext) hoverBuilder;
  final IndexedDragTargetGridIndicatorStrategy indicatorStrategy;
  final void Function(T) onAccept;
  final VoidCallback onLeave;
  final VoidCallback onMove;
  final bool? Function(T) onWillAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      builder: (context, candidates, rejects) {
        final child = this.child;

        // if this index is not highlighted, return the child
        if (!targeted) {
          return child ?? const SizedBox.shrink();
        }

        final indicator = hoverBuilder.call(context);

        // if there is no child, display the indicator
        if (child == null) {
          return indicator ?? const SizedBox.shrink();
        }

        return getWidgetForIndicatorStrategy(
          child: child,
          indicator: indicator,
          strategy: indicatorStrategy,
        );
      },
      onMove: (details) {
        final data = details.data;
        final willAccept = onWillAccept(data);

        if (willAccept == false) {
          return;
        }

        onMove();
      },
      onLeave: (_) => onLeave(),
      onAcceptWithDetails: (details) {
        final data = details.data;

        if (targeted) {
          final willAccept = onWillAccept(data);

          if (willAccept == false) {
            return;
          }

          onAccept(data);
        }
      },
    );
  }
}
