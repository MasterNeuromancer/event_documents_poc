import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

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
          child: const Text('Rooms Screen'),
        ),
        const SizedBox(
          height: 65.0,
        ),
      ],
    );
  }
}
