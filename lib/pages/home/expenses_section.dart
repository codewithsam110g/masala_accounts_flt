import 'package:flutter/material.dart';

class ExpensesSection extends StatefulWidget {
  const ExpensesSection({super.key});

  @override
  State<ExpensesSection> createState() => _ExpensesSectionState();
}

class _ExpensesSectionState extends State<ExpensesSection> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Expenses Section"),
      ),
    );
  }
}
