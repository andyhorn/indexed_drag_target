import 'package:flutter/widgets.dart';
import 'package:indexed_drag_target/src/shared/shared.dart';
import 'package:indexed_drag_target/src/widgets/indexed_drag_target_indicator.dart';

class IndexedDragTargetWrap<T extends Object> extends StatefulWidget {
  const IndexedDragTargetWrap({
    super.key,
    required this.children,
    required this.count,
    required this.onAccept,
    this.onWillAccept,
  });

  final List<Widget> children;
  final int count;
  final OnAcceptCallback<T> onAccept;
  final OnWillAcceptCallback<T>? onWillAccept;

  @override
  State<IndexedDragTargetWrap<T>> createState() =>
      _IndexedDragTargetWrapState<T>();
}

class _IndexedDragTargetWrapState<T extends Object>
    extends State<IndexedDragTargetWrap<T>>
    with DragTargetUtilityMixin {
  @override
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
          children: [
            for (var i = 0; i < numRows; i++) ...[
              IntrinsicHeight(
                child: Builder(
                  builder: (context) {
                    final rowIndex = i * (widget.count + 1);
                    int getChildIndex(int i, int j) =>
                        i * (widget.count + 1) + j + 1;

                    return Row(
                      children: [
                        IndexedDragTargetIndicator(
                          key: keys[rowIndex],
                          visible: index == rowIndex,
                          direction: Axis.horizontal,
                        ),
                        for (var j = 0; j < widget.count; j++) ...[
                          if (i * widget.count + j < length) ...[
                            Expanded(
                              child: widget.children[getChildIndex(i, j)],
                            ),
                            IndexedDragTargetIndicator(
                              key: keys[getChildIndex(i, j)],
                              visible: index == getChildIndex(i, j),
                              direction: Axis.horizontal,
                            ),
                          ] else ...[
                            const Expanded(child: SizedBox.shrink()),
                          ],
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
      onMove: (details) {
        final data = details.data;
        final index = getIndicatorIndex(details.offset);

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

  int getNumRows() {
    final fullRows = widget.children.length ~/ widget.count;
    final remainder = widget.children.length % widget.count;

    return fullRows + (remainder == 0 ? 0 : 1);
  }

  int getNumIndicators() {
    return widget.children.length + getNumRows();
  }

  int? getAdjustedIndex() {
    if (index case final index?) {
      return index - (index ~/ (widget.count + 1));
    }

    return null;
  }
}
