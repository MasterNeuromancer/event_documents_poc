import 'package:event_documents_poc/firebase/firebase_providers.dart';
import 'package:event_documents_poc/widgets/custom_nav_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScaffoldWithNavRail extends ConsumerWidget {
  const ScaffoldWithNavRail({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Documents POC'),
        actions: [
          IconButton(
            onPressed: () => ref.read(firebaseAuthProvider).signOut(),
            // icon: const Text(
            //   'Exit App',
            //   style: TextStyle(
            //     color: Colors.red,
            //   ),
            // ),
            icon: const Icon(
              Icons.cancel,
            ),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          const CustomNavRail(),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
