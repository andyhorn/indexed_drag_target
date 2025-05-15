import 'package:flutter/widgets.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';
import 'package:indexed_drag_target/src/widgets/indexed_drag_target_indicator.dart';
import 'package:indexed_drag_target/src/widgets/wrap/row_indices.dart';

class IndexedDragTargetWrap<T extends Object> extends StatefulWidget {
  const IndexedDragTargetWrap({
    super.key,
    required this.children,
    required this.count,
    required this.onAccept,
    this.onWillAccept,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final int count;
  final OnAcceptCallback<T> onAccept;
  final OnWillAcceptCallback<T>? onWillAccept;
  final double spacing;
  final double runSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  State<IndexedDragTargetWrap<T>> createState() =>
      _IndexedDragTargetWrapState<T>();
}

class _IndexedDragTargetWrapState<T extends Object>
    extends State<IndexedDragTargetWrap<T>> {
  final keys = <GlobalKey>[];

  int? index;

  int get length => widget.children.length;

  @override
  void initState() {
    super.initState();

    keys.addAll(generateKeys(getNumIndicators()));
  }

  @override
  void didUpdateWidget(covariant IndexedDragTargetWrap<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didChangeLength = oldWidget.children.length != widget.children.length;
    final didChangeCount = oldWidget.count != widget.count;

    if (didChangeLength || didChangeCount) {
      keys.clear();
      keys.addAll(generateKeys(getNumIndicators()));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final numRows = getNumRows();

    return DragTarget<T>(
      builder: (context, candidates, rejects) {
        return Column(
          spacing: widget.runSpacing,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: [
            for (var i = 0; i < numRows; i++) ...[
              Builder(
                builder: (context) {
                  final indices = RowIndices(row: i, count: widget.count);

                  return IntrinsicHeight(
                    child: Row(
                      spacing: widget.spacing / 2,
                      children: [
                        IndexedDragTargetIndicator(
                          key: keys[indices.firstIndicator()],
                          visible: index == indices.firstIndicator(),
                          direction: Axis.horizontal,
                        ),
                        for (var j = 0; j < widget.count; j++) ...[
                          if (i * widget.count + j < length) ...[
                            Expanded(child: widget.children[indices.child(j)]),
                            IndexedDragTargetIndicator(
                              key: keys[indices.indicator(j)],
                              visible: index == indices.indicator(j),
                              direction: Axis.horizontal,
                            ),
                          ] else ...[
                            const Expanded(child: SizedBox.shrink()),
                            const SizedBox.shrink(),
                          ],
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
      onMove: (details) {
        final data = details.data;
        final index = getIndexOfClosestKey(keys, details.offset);

        if (widget.onWillAccept case final onWillAccept?) {
          if (!onWillAccept(data, index)) {
            return;
          }
        }

        setState(() => this.index = index);
      },
      onLeave: (_) => setState(() => index = null),
      onAcceptWithDetails: (details) {
        final data = details.data;
        final index = getAdjustedIndex();

        if (index case final index?) {
          if (widget.onWillAccept case final onWillAccept?) {
            if (!onWillAccept(data, index)) {
              return;
            }
          }

          widget.onAccept(data, index);
          setState(() => this.index = null);
        }
      },
    );
  }

  int getNumIndicators() {
    return widget.children.length + getNumRows();
  }

  int getNumRows() {
    if (widget.children.isEmpty) {
      return 1;
    }

    final fullRows = widget.children.length ~/ widget.count;
    final remainder = widget.children.length % widget.count;

    return fullRows + (remainder == 0 ? 0 : 1);
  }

  int? getAdjustedIndex() {
    if (index case final index?) {
      return index - (index ~/ (widget.count + 1));
    }

    return null;
  }
}
