import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  _HomeBaseState createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  int _selectedIndex = 0; // Initialize the selected index
  final List<Widget> _pages = [
    const Home(), // Add your Home widget here
    const Center(child: Text('Analysis')),
    const Center(child: Text('Wallet')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeBase'),
        backgroundColor: const Color(0xFF3E7C78),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF3E7C78),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home),
              _buildNavItem(1, Icons.trending_up),
              const SizedBox(width: 40),
              _buildNavItem(2, Icons.wallet),
              _buildNavItem(3, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF3E7C78) : Colors.transparent,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
