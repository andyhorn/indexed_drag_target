import 'package:example/pages/column.dart';
import 'package:example/pages/grid.dart';
import 'package:example/pages/row.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/column',
      routes: {
        '/row': (context) => const RowPage(),
        '/column': (context) => const ColumnPage(),
        '/grid': (context) => const GridPage(),
      },
    );
  }
}
