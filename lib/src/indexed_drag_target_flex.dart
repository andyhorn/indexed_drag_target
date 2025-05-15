import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:indexed_drag_target/src/indexed_drag_target_indicator.dart';
import 'package:indexed_drag_target/src/shared/mixin.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';

class IndexedDragTargetFlex<T extends Object> extends StatefulWidget {
  const IndexedDragTargetFlex({
    super.key,
    required this.children,
    required this.onAccept,
    required this.direction,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 0.0,
    this.clipBehavior = Clip.none,
    this.verticalDirection = VerticalDirection.down,
    this.onWillAccept,
    this.textBaseline,
    this.textDirection,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  final OnAcceptCallback<T> onAccept;
  final OnWillAcceptCallback<T>? onWillAccept;
  final Axis direction;
  final double spacing;
  final Clip clipBehavior;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;

  @override
  State<IndexedDragTargetFlex<T>> createState() =>
      _IndexedDragTargetFlexState<T>();
}

class _IndexedDragTargetFlexState<T extends Object>
    extends State<IndexedDragTargetFlex<T>>
    with DragTargetUtilityMixin {
  @override
  final keys = <GlobalKey>[];

  int? index;

  @override
  void initState() {
    super.initState();

    keys.addAll(generateKeys(getNumIndicators()));
  }

  @override
  void didUpdateWidget(covariant IndexedDragTargetFlex<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.children, widget.children)) {
      keys.clear();
      keys.addAll(generateKeys(getNumIndicators()));
      setState(() {});
    }
  }

  int getNumIndicators() {
    return widget.children.length + 1;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      builder: (context, candidates, reject) {
        final flex = Flex(
          direction: widget.direction,
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          spacing: widget.spacing / 2,
          clipBehavior: widget.clipBehavior,
          textBaseline: widget.textBaseline,
          textDirection: widget.textDirection,
          verticalDirection: widget.verticalDirection,
          children: [
            for (var i = 0; i < widget.children.length; i++) ...[
              IndexedDragTargetIndicator(
                key: keys[i],
                visible: index == i,
                direction: widget.direction,
              ),
              widget.children[i],
            ],
            IndexedDragTargetIndicator(
              key: keys.last,
              visible: index == keys.length - 1,
              direction: widget.direction,
            ),
          ],
        );

        return switch (widget.direction) {
          Axis.horizontal => IntrinsicHeight(child: flex),
          Axis.vertical => IntrinsicWidth(child: flex),
        };
      },
      onMove: (details) {
        final index = getIndicatorIndex(details.offset);
        setState(() => this.index = index);
      },
      onAcceptWithDetails: (details) {
        final index = this.index;
        final data = details.data;

        if (index == null) {
          return;
        }

        if (widget.onWillAccept case final onWillAccept?) {
          if (!onWillAccept(data, index)) {
            return;
          }
        }

        widget.onAccept(data, index);

        setState(() => this.index = null);
      },
      onLeave: (_) => setState(() => index = null),
    );
  }
}
