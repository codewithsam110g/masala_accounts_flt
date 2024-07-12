import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masala_accounts/pages/home/home_page.dart';
import 'package:masala_accounts/auth/login_page.dart';

class PageManager extends StatelessWidget {
  const PageManager({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return HomePage();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something Went Wrong!'));
            } else {
              return const Align(
                alignment: AlignmentDirectional.center,
                child: LoginPage(),
              );
            }
          },
        ),
      );
}
