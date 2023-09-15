import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerScreen extends ConsumerWidget {
  const ServerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authProviders = ref.watch(authProvidersProvider);
    return Column(
      children: [
        const SizedBox(
          height: 65.0,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Server Screen'),
        ),
        const SizedBox(
          height: 65.0,
        ),
      ],
    );
  }
}
