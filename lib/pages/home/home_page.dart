import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masala_accounts/pages/home/accounts_section.dart';
import 'package:masala_accounts/pages/home/history_section.dart';
import 'package:masala_accounts/pages/home/expenses_section.dart';
import 'package:masala_accounts/pages/home/profile_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  void _onItemTapped(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(index),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNavItem(Icons.account_balance_rounded, 0),
              _buildNavItem(Icons.history_rounded, 1),
              const SizedBox(width: 48.0), // Space for the notch
              _buildNavItem(Icons.calculate_rounded, 2),
              _buildNavItem(Icons.person_rounded, 3),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _showBody(int index) {
    switch (index) {
      case 0:
        {
          return const AccountsSection();
        }
      case 1:
        {
          return const HistorySection();
        }
      case 2:
        {
          return const ExpensesSection();
        }
      case 3:
        {
          return const ProfileSection();
        }
      default:
        {
          return const AccountsSection();
        }
    }
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: SizedBox(
          height: 56.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onItemTapped(index),
              borderRadius: BorderRadius.circular(28.0),
              splashColor: Colors.blue.withOpacity(0.2),
              highlightColor: Colors.blue.withOpacity(0.1),
              child: Center(
                child: Icon(icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
