import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/page/on_boarding.dart';
import 'package:kasir_cerdas/provider/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  static const route = '/wrapper';

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return StreamBuilder<User?>(
      stream: auth.changeState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return (snapshot.data != null)
              ? const MainPage()
              : const OnBoardingPage();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
