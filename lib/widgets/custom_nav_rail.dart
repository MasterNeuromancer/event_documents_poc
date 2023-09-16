import 'package:event_documents_poc/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavRail extends StatefulWidget {
  const CustomNavRail({super.key});

  @override
  State<CustomNavRail> createState() => _CustomNavRailState();
}

class _CustomNavRailState extends State<CustomNavRail> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAlignment = -1.0;

  _updateIndex(int index) {
    setState(() {
      switch (index) {
        case 0: //home
          context.go(AppPages.home);
          break;
        case 1: //search
          context.go(AppPages.rooms);
          break;
        case 2: //top 10
          context.go(AppPages.server);
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      groupAlignment: groupAlignment,
      onDestinationSelected: (int index) {
        _updateIndex(index);
      },
      labelType: labelType,
      // leading: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: () {
      //     // Add your onPressed code here!
      //   },
      //   child: const Icon(Icons.add),
      // ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.folder_copy_outlined),
          selectedIcon: Icon(Icons.folder_copy),
          label: Text('User Docs'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.room_service_outlined),
          selectedIcon: Icon(Icons.room_service),
          label: Text('Rooms'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.code_outlined),
          selectedIcon: Icon(Icons.code),
          label: Text('Server'),
        ),
      ],
    );
  }
}
