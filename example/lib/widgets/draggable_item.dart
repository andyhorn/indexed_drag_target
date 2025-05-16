import 'package:flutter/material.dart';

class DraggableItem extends StatelessWidget {
  const DraggableItem({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: id,
      feedback: Material(child: _Box(id, dragging: true)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: _Box(id, dragging: false),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box(this.id, {required this.dragging});

  final String id;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dragging ? 36 : 48,
      width: dragging ? 36 : 48,
      color: dragging ? Colors.blue.shade400 : Colors.blue,
      child: FittedBox(child: Text(id, style: TextStyle(color: Colors.white))),
    );
  }
}
