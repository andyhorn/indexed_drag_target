import 'package:example/widgets/app_drawer.dart';
import 'package:example/widgets/draggable_item.dart';
import 'package:example/widgets/selected_item.dart';
import 'package:flutter/material.dart';
import 'package:indexed_drag_target/indexed_drag_target.dart';

class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  final ids = List.generate(5, (i) => 'item_$i');
  final selected = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Column'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              selected.clear();
              setState(() {});
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 126,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Drag these items to the space to the right.'),
                  const SizedBox(height: 12),
                  if (ids.every(selected.contains)) ...[
                    Expanded(
                      child: Center(
                        child: Text(
                          'No items remaining',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ] else ...[
                    for (final id in ids) ...[
                      if (!selected.contains(id)) ...[
                        DraggableItem(id: id),
                        const SizedBox(height: 6),
                      ],
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: IndexedDragTargetColumn<String>(
                spacing: 6,
                onAccept: (id, index) {
                  final newList = [...selected];
                  final previousIndex = newList.indexOf(id);

                  newList.insert(index, id);

                  if (previousIndex != -1) {
                    newList.removeAt(
                      previousIndex + (previousIndex < index ? 0 : 1),
                    );
                  }

                  selected.clear();
                  selected.addAll(newList);

                  setState(() {});
                },
                children: [
                  for (final id in selected) ...[SelectedItem(id: id)],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
