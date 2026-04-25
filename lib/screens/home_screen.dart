import 'package:flutter/material.dart';
import '../widgets/dashboard_view.dart';
import '../widgets/history_view.dart';
import '../widgets/alerts_view.dart';
import '../widgets/calibrate_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.wifi_tethering, color: Color(0xFF00FF41), size: 20),
            const Spacer(),
            const Text(
              'SYSTEM_OS_V1.0',
              style: TextStyle(
                color: Color(0xFF00FF41),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(Icons.account_circle_outlined, color: const Color(0xFF00FF41).withOpacity(0.8)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardView(),
          HistoryView(),
          AlertsView(),
          CalibrateView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF00FF41),
          unselectedItemColor: Colors.grey[700],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
          onTap: (index) {
             setState(() {
               _selectedIndex = index;
             });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: _selectedIndex == 0 ? const Border(top: BorderSide(color: Color(0xFF00FF41), width: 2)) : null,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.grid_view_rounded),
                ),
              ),
              label: 'DASHBOARD',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: _selectedIndex == 1 ? const Border(top: BorderSide(color: Color(0xFF00FF41), width: 2)) : null,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.show_chart),
                ),
              ),
              label: 'HISTORY',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: _selectedIndex == 2 ? const Border(top: BorderSide(color: Color(0xFF00FF41), width: 2)) : null,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.notifications_outlined),
                ),
              ),
              label: 'ALERTS',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: _selectedIndex == 3 ? const Border(top: BorderSide(color: Color(0xFF00FF41), width: 2)) : null,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.tune),
                ),
              ),
              label: 'CALIBRATE',
            ),
          ],
        ),
      ),
    );
  }
}
