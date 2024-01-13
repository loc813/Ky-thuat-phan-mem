import 'package:flutter/material.dart';

import '../screens/screens.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
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
    const bottomNavigationBarItem = BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "Favotires",
          );
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
          bottomNavigationBarItem,
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Profile",
          ),
        ]);
  }
}
