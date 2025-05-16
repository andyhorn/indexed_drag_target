import 'package:example/widgets/draggable_item.dart';
import 'package:example/widgets/selected_item.dart';
import 'package:flutter/material.dart';
import 'package:indexed_drag_target/indexed_drag_target.dart';

class RowPage extends StatefulWidget {
  const RowPage({super.key});

  @override
  State<RowPage> createState() => _RowPageState();
}

class _RowPageState extends State<RowPage> {
  final ids = List.generate(5, (i) => 'item_$i');
  final selected = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row'),
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
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: IndexedDragTargetRow<String>(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Drag these items to the space above.'),
            ),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  if (ids.every(selected.contains)) ...[
                    Expanded(
                      child: Text(
                        'No items remaining.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  for (final id in ids) ...[
                    if (!selected.contains(id)) ...[DraggableItem(id: id)],
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
