import 'package:flutter/material.dart';
import 'package:music_app/widgets/widgets.dart';

import 'screens.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8)
          ])),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Play Screen"),
        ),
        bottomNavigationBar: const CustomNavBar(),
      ),
    );
  }
}

class _CustomNavBar extends StatefulWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<_CustomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const PlayScreen(),
    const ProfileScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _screens[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple.shade800,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "Favotires",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outlined),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Profile",
          ),
        ]);
  }
}
