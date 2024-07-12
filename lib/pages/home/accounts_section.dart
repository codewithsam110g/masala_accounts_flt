import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  State<AccountsSection> createState() => _AccountsSectionState();
}

class _AccountsSectionState extends State<AccountsSection> {
  final String photoUrl = FirebaseAuth.instance.currentUser?.photoURL ?? "NAN";
  final String username =
      FirebaseAuth.instance.currentUser?.displayName ?? "User";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accounts")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, kBottomNavigationBarHeight),
        child: Column(
          children: [
            _balanceCard(432),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Total Accounts",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                        child: Text(
                          "Total Accounts Managed by you",
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff606a85)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 4, 8),
                              child: ChoiceChip(
                                label: const Text(
                                  "All",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                selected: true,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 8),
                              child: ChoiceChip(
                                label: const Text(
                                  "Incoming",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                selected: false,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
                              child: ChoiceChip(
                                label: const Text(
                                  "Outgoing",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                selected: false,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16,0,16,0),
                        child: const Divider(thickness: 1.5),
                      ),
                      _buildAccount(1, "Sam", 100),
                      _buildAccount(2, "Sam", 190),
                      _buildAccount(3, "Sam", -151),
                      _buildAccount(4, "Sam", 112),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccount(int number, String name, double amount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "$number",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  child: Text(
                    "$amount",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1.5),
        ],
      ),
    );
  }

  Widget _balanceCard(double balance) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: (photoUrl != "NAN")
                        ? Image.network(photoUrl, width: 40)
                        : const Icon(Icons.person_rounded),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome $username",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  "Total Balance",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Icon(Icons.trending_up_rounded,
                      color: Colors.green, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    "\u20b9 $balance",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
