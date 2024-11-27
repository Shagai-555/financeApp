import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../conf.dart';

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Өглөөний Мэнд'; // Good Morning
    } else if (hour < 18) {
      return 'Өдрийн Мэнд'; // Good Afternoon
    } else {
      return 'Оройн Мэнд'; // Good Evening
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110), // Set height for the AppBar
        child: ClipPath(
          clipper: UShapeClipper(), // Custom clipper for U shape
          child: Container(
            color: const Color.fromRGBO(47, 126, 121, 1), // Background color
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              leading: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        DateTime.now().hour < 12
                            ? Icons.wb_sunny // Sun icon for morning
                            : DateTime.now().hour < 18
                                ? Icons.wb_cloudy // Cloud icon for afternoon
                                : Icons.nights_stay, // Moon icon for evening
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getGreeting(), // Use userName from Config
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      Config.displayName, // Use userName from Config
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ), // Adjust leading width to fit the content
              leadingWidth: 150,
              actions: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        255, 255, 255, 0.06), // Background color
                    borderRadius: BorderRadius.circular(7), // Rounded corners
                  ),
                  margin: const EdgeInsets.only(top: 5, right: 8),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/notif.svg',
                    ),
                    onPressed: () {
                      // Handle notification button press
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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

// Custom clipper for U shape
class UShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30); // Start from the left bottom
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30); // U shape
    path.lineTo(size.width, 0); // Right top corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Reclip whenever the widget rebuilds
  }
}
