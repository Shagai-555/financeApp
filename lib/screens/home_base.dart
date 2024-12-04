import 'package:finance/screens/deposit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './home.dart';
import './wallet.dart';
import './analys.dart'; 
import './profile.dart';
import './../conf.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({super.key});

  @override
  _HomeBaseState createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const Home(),
    const AnalysisScreen(), 
    const WalletScreen(), 
    const ProfileScreen(), 
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Өглөөний Мэнд';
    } else if (hour < 18) {
      return 'Өдрийн Мэнд'; 
    } else {
      return 'Оройн Мэнд';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 50, right: 20, bottom: 20),
              height: 150, 
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3E7C78), Color(0xFF2A6A61)], // Gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        DateTime.now().hour < 12
                            ? Icons.wb_sunny 
                            : DateTime.now().hour < 18
                                ? Icons.wb_cloudy
                                : Icons.nights_stay, 
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            Config.displayName, 
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                          255, 255, 255, 0.06),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset('assets/notif.svg'),
                      onPressed: () {
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 120,
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DepositScreen()),
                );
              },
              backgroundColor: const Color(0xFF3E7C78),
              shape: const CircleBorder(),
              elevation: 10,
              tooltip: 'Add',
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null, // Hide on other pages
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        elevation: 10,
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
      onTap: () {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
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
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 28,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
