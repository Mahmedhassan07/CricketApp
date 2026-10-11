import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_view.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: const PlaceholderView(
        icon: Icons.groups_outlined,
        title: 'Teams coming soon',
        message: 'Follow your favourite teams and see their fixtures here.',
      ),
    );
  }
}
