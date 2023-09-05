import 'dart:async';
import 'dart:ui';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:final_mobile/features/profile/presentation/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../explorer/presentation/view/explorer.dart';
import '../../../home/presentation/view/home.dart';
import '../../../home/presentation/viewmodel/home_view_model.dart';
import '../../../profile/presentation/viewmodel/profile_view_model.dart';
import '../../../search/presentation/view/search_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  final double shakeThreshold = 15.0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  int _selectedIndex = 0;

  @override
  void initState() {
    // _selectedIndex = 0;
    _accelerometerSubscription =
        accelerometerEvents?.listen((AccelerometerEvent? event) {
      if (event != null) {
        // Access accelerometer data here
        double x = event.x;
        double y = event.y;
        double z = event.z;

        // Implement shake detection logic here and change the bottom navigation index accordingly
        if (x.abs() > shakeThreshold ||
            y.abs() > shakeThreshold ||
            z.abs() > shakeThreshold) {
          setState(() {
            _selectedIndex = (_selectedIndex + 1) % lstBottomScreens.length;
          });
        }
      }
    });
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.getAllBlogs();
      homeViewModel.getBookmarkedBlogs();
      homeViewModel.getUserBlogs();
      ref.watch(profileViewModelProvider.notifier).getAllProfile();
    });
    super.initState();
  }

  final lstBottomScreens = [
    const Home(),
    const ExplorerView(),
    const SearchView(),
    const ProfileView(),
  ];

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          lstBottomScreens.elementAt(_selectedIndex),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.hiking),
                  label: 'Explorer',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
