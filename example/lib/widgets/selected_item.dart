import 'package:flutter/material.dart';

class SelectedItem extends StatelessWidget {
  const SelectedItem({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48 * 2,
      width: 48 * 2,
      color: Colors.blue,
      child: Text(id, style: TextStyle(color: Colors.white)),
    );
  }
}
