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
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Event Documents POC'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () => ref.read(firebaseAuthProvider).signOut(),
              child: const Row(
                children: [
                  Text('Logout'),
                  SizedBox(
                    width: 7.5,
                  ),
                  Icon(
                    Icons.logout,
                  )
                ],
              ),
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
