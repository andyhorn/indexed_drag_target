import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          children: [
            ListTile(
              title: const Text('Row Example'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/row'),
            ),
            ListTile(
              title: const Text('Column Example'),
              onTap:
                  () => Navigator.of(context).pushReplacementNamed('/column'),
            ),
            ListTile(
              title: const Text('Grid Example'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/grid'),
            ),
          ],
        ),
      ),
    );
  }
}
