import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masala_accounts/objects/account.dart';

class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  State<AccountsSection> createState() => _AccountsSectionState();
}

class _AccountsSectionState extends State<AccountsSection> {
  final String photoUrl = FirebaseAuth.instance.currentUser?.photoURL ?? "NAN";
  final String username =
      FirebaseAuth.instance.currentUser?.displayName ?? "User";

  late List<Account> accounts = [];
  int filterIndex = 0;
  double sum = 0.0;
  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  void fetchAccounts() async {
    var acc = await Account.readAllAccounts();
    double d = 0.0;
    for (Account ac in acc) {
      d += ac.amount;
    }
    setState(() {
      accounts = acc;
      sum = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accounts")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, kBottomNavigationBarHeight),
        child: Column(
          children: [
            _balanceCard(sum),
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
                                selected: filterIndex == 0,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {
                                  setState(() {
                                    filterIndex = 0;
                                  });
                                },
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
                                selected: filterIndex == 1,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {
                                  setState(() {
                                    filterIndex = 1;
                                  });
                                },
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
                                selected: filterIndex == 2,
                                labelPadding: EdgeInsets.zero,
                                onSelected: (bool selected) {
                                  setState(() {
                                    filterIndex = 2;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Divider(thickness: 1.5),
                      ),
                      ..._getAccountList(),
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

  List<Widget> _getAccountList() {
    List<Account> accs = [];
    fetchAccounts();
    for (Account ac in accounts) {
      if (filterIndex == 0) {
        accs.add(ac);
      } else if (filterIndex == 1 && ac.amount >= 0.0) {
        accs.add(ac);
      } else if (filterIndex == 2 && ac.amount < 0.0) {
        accs.add(ac);
      }
    }
    accs.sort((a, b) => a.amount.compareTo(b.amount));
    int num = 1;
    List<Widget> wids = [];
    for (Account ac in accs) {
      wids.add(_buildAccount(num, ac));
      num++;
    }
    return wids;
  }

  Widget _buildAccount(int number, Account ac) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 0),
      child: GestureDetector(
        onTap: () {},
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Delete Account"),
                  content: Text(
                      "Do want to delete this account ${ac.name} with amount of ${ac.amount} /- ?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Account.deleteAccount(ac.guid);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("No"),
                    ),
                  ],
                );
              });
        },
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
                    ac.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    child: Text(
                      "${ac.amount}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.5),
          ],
        ),
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
