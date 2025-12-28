import 'package:flutter/material.dart';

import 'home_page.dart';
import 'services/feature_flag_service.dart';
import 'services/feature_gate.dart';
import 'demo_page.dart';
import 'feature_flags_admin_page.dart';

class MainNavigation extends StatefulWidget {
  final FeatureFlagService flagService;
  final FeatureGate gate;

  const MainNavigation({super.key, required this.flagService, required this.gate});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 1;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      FeatureFlagsPage(flagService: widget.flagService),
      DemoPage(flagService: widget.flagService, gate: widget.gate),
    ];
  }

  final List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.storage),
      label: 'Database Demo',
    ),
    NavigationDestination(
      icon: Icon(Icons.toggle_on),
      label: 'Feature Flags',
    ),
    NavigationDestination(
      icon: Icon(Icons.apps),
      label: 'Demo',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
