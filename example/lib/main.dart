import 'dart:math' show Point;

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
  final List<List<String?>> children = [
    ['a', null, 'b'],
    [null, null, 'c'],
    [null, null, null],
  ];

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
                child: IndexedDragTargetSlotIndicatorTheme(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.orange,
                  child: IndexedDragTargetGrid<String>(
                    columns: 3,
                    rows: 3,
                    children: [
                      for (var i = 0; i < children.length; i++) ...[
                        for (var j = 0; j < children[i].length; j++) ...[
                          if (children[i][j] != null) ...[
                            IndexedDragTargetGridEntry(
                              point: Point(i, j),
                              child: Container(
                                color: Colors.blue.shade700,
                                child: Text(
                                  children[i][j] ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ],
                    onAccept: (id, point) {
                      children[point.x.toInt()][point.y.toInt()] = id;
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < 5; i++) ...[
                    if (!children.any(
                      (list) => list.contains('${i ~/ 3}-${i % 3}'),
                    )) ...[
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
