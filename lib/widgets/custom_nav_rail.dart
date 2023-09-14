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
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: Text('First'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bookmark_border),
          selectedIcon: Icon(Icons.book),
          label: Text('Second'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.star_border),
          selectedIcon: Icon(Icons.star),
          label: Text('Third'),
        ),
      ],
    );
  }
}
