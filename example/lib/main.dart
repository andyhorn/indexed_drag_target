import 'package:flutter/material.dart';
import 'package:indexed_drag_target/indexed_drag_target.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final children = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: IndexedDragTargetIndicatorTheme(
                  child: IndexedDragTargetColumn<String>(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 4,
                    children:
                        children
                            .map(
                              (id) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.all(8),
                                color: Colors.blue.shade700,
                                child: Text(
                                  id,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                    onAccept: (id, index) {
                      final newItems = [...children];
                      final previousIndex = newItems.indexOf(id);

                      newItems.insert(index, id);

                      if (previousIndex != -1) {
                        newItems.removeAt(
                          previousIndex + (previousIndex < index ? 0 : 1),
                        );
                      }

                      children.clear();
                      children.addAll(newItems);
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < 5; i++) ...[
                    if (!children.contains('item_$i')) ...[
                      Draggable<String>(
                        data: 'item_$i',
                        feedback: Container(
                          height: 28,
                          width: 28,
                          color: Colors.blue,
                        ),
                        child: Container(
                          height: 24,
                          width: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
