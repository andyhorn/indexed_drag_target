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
  final children = [
    'item_1',
    null,
    'item_2',
    null,
    null,
    'item_3',
    null,
    'item_4',
    null,
  ];

  @override
  Widget build(BuildContext context) {
    final allSelected = children.every((id) => id != null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              children.setAll(0, List.generate(9, (_) => null));
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
              child: IndexedDragTargetGridCellTheme(
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 1),
                  outside: BorderSide(width: 2),
                ),
                child: IndexedDragTargetGrid<String>(
                  crossAxisCount: 3,
                  rows: 3,
                  indicatorBuilder: defaultIndicatorBuilder,
                  onAccept: (id, index) {
                    children[index] = id;
                    setState(() {});
                  },
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (children[i] case final id?) ...[
                        SelectedItem(id: id),
                      ] else ...[
                        null,
                      ],
                    ],
                  ],
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
                  for (var i = 0; i < children.length; i++) ...[
                    if (!children.contains('item_$i')) ...[
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
