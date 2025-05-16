import 'dart:math';

import 'package:example/widgets/app_drawer.dart';
import 'package:example/widgets/draggable_item.dart';
import 'package:example/widgets/selected_item.dart';
import 'package:flutter/material.dart';
import 'package:indexed_drag_target/indexed_drag_target.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  final List<List<String?>> children = [
    ['item_1', null, 'item_2'],
    [null, null, 'item_3'],
    [null, 'item_4', null],
  ];

  bool isSelected(String? id) => children.any((list) => list.contains(id));

  @override
  Widget build(BuildContext context) {
    final entries = <IndexedDragTargetGridEntry>[];

    for (var row = 0; row < children.length; row++) {
      for (var column = 0; column < children.first.length; column++) {
        if (children[row][column] case final id?) {
          entries.add(
            IndexedDragTargetGridEntry(
              point: Point(column, row),
              child: SelectedItem(id: id),
            ),
          );
        }
      }
    }

    final allSelected = children.every(
      (list) => list.every((id) => id != null),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              for (final list in children) {
                list.clear();
                list.addAll([null, null, null]);
              }

              setState(() {});
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IndexedDragTargetSlotIndicatorTheme(
                borderRadius: BorderRadius.circular(4),
                color: Colors.orange,
                child: IndexedDragTargetGrid<String>(
                  columns: 3,
                  rows: 3,
                  onAccept: (id, point) {
                    children[point.y.toInt()][point.x.toInt()] = id;
                    setState(() {});
                  },
                  children: entries,
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  if (allSelected) ...[
                    Expanded(
                      child: Text(
                        'No items remaining',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                  for (
                    var i = 0;
                    i < children.length * children.first.length;
                    i++
                  ) ...[
                    if (!isSelected('item_$i')) ...[
                      DraggableItem(id: 'item_$i'),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
