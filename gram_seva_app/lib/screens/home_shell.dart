import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'customer/customer_home_screen.dart';
import 'customer/my_bookings_screen.dart';
import 'customer/help_screen.dart';
import 'customer/household_profile_screen.dart';
import 'worker/worker_requests_screen.dart';
import 'worker/worker_active_jobs_screen.dart';
import 'worker/worker_earnings_screen.dart';
import 'worker/worker_profile_screen.dart';

/// Root shell shown after language + mobile login. Which experience
/// renders - household or worker - follows AppState.activeRole. There is
/// no peer toggle here anymore: households land in this shell by default,
/// and the only doors into worker mode are the de-emphasized entry points
/// on the household side (CustomerHomeScreen's banner,
/// HouseholdProfileScreen's button) and back out again
/// (WorkerProfileScreen's "Browse as a customer" link).
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AppState>().activeRole;
    return role == UserRole.household ? const _HouseholdShell() : const _WorkerShell();
  }
}

class _HouseholdShell extends StatefulWidget {
  const _HouseholdShell();

  @override
  State<_HouseholdShell> createState() => _HouseholdShellState();
}

class _HouseholdShellState extends State<_HouseholdShell> {
  int _index = 0;

  static const _titles = ['', 'My bookings', 'Help', 'Profile'];

  @override
  Widget build(BuildContext context) {
    const screens = [
      CustomerHomeScreen(),
      MyBookingsScreen(),
      HelpScreen(),
      HouseholdProfileScreen(),
    ];

    return Scaffold(
      appBar: _index == 0 ? null : AppBar(title: Text(_titles[_index])),
      body: SafeArea(child: IndexedStack(index: _index, children: screens)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline_rounded), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _WorkerShell extends StatefulWidget {
  const _WorkerShell();

  @override
  State<_WorkerShell> createState() => _WorkerShellState();
}

class _WorkerShellState extends State<_WorkerShell> {
  int _index = 0;

  static const _titles = ['New requests', 'Active jobs', 'Earnings', 'Profile'];

  @override
  Widget build(BuildContext context) {
    const screens = [
      WorkerRequestsScreen(),
      WorkerActiveJobsScreen(),
      WorkerEarningsScreen(),
      WorkerProfileScreen(),
    ];

    return Scaffold(
      appBar: _index == 0 ? null : AppBar(title: Text(_titles[_index])),
      body: SafeArea(child: IndexedStack(index: _index, children: screens)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), label: 'Active jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.payments_outlined), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
