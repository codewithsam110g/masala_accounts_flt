import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Account {
  String guid;
  String name;
  double amount;
  String lastUpdated;

  Account({
    required this.guid,
    required this.name,
    required this.amount,
    required this.lastUpdated,
  });

  factory Account.fromJson(Map<dynamic, dynamic> json) {
    double val = 0.0;
    if (json['amount'] is int) {
      val = json['amount'].toDouble();
    } else if (json['amount'] is double) {
      val = json['amount'];
    } else if (json['amount'] is String) {
      val = double.tryParse(json['amount']) ?? 0.0;
    }
    return Account(
      guid: json['guid'] as String,
      name: json['name'] as String,
      amount: val,
      lastUpdated: json['lastUpdated'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'name': name,
      'amount': amount,
      'lastUpdated': lastUpdated,
    };
  }

  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  static final String? userId = FirebaseAuth.instance.currentUser?.uid;

  static Future<Account> createAccount(String name, double amount) async {
    if (userId != null) {
      DatabaseReference newAccountRef =
          _dbRef.child('users/$userId/accounts').push();
      String guid = newAccountRef.key!;
      String lastUpdated = DateTime.now().toIso8601String();

      Account account = Account(
        guid: guid,
        name: name,
        amount: amount,
        lastUpdated: lastUpdated,
      );

      await newAccountRef.set(account.toJson());
      return account;
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  static Future<Account?> readAccount(String accountId) async {
    if (userId != null) {
      DataSnapshot snapshot =
          await _dbRef.child('users/$userId/accounts/$accountId').get();
      if (snapshot.exists) {
        return Account.fromJson(snapshot.value as Map<dynamic, dynamic>);
      }
    } else {
      throw Exception("No authenticated user found.");
    }
    return null;
  }

  static Future<void> updateAccount(Account account) async {
    if (userId != null) {
      account.lastUpdated = DateTime.now().toIso8601String();
      await _dbRef
          .child('users/$userId/accounts/${account.guid}')
          .update(account.toJson());
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  static Future<void> deleteAccount(String accountId) async {
    if (userId != null) {
      await _dbRef.child('users/$userId/accounts/$accountId').remove();
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  static Future<List<Account>> readAllAccounts() async {
    if (userId != null) {
      DataSnapshot snapshot =
          await _dbRef.child('users/$userId/accounts').get();
      if (snapshot.exists) {
        List<Account> accounts = [];
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          accounts.add(Account.fromJson(value as Map<dynamic, dynamic>));
        });
        return accounts;
      }
    } else {
      throw Exception("No authenticated user found.");
    }
    return [];
  }
}
