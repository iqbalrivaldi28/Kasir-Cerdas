import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/signin_page.dart';
import 'package:kasir_cerdas/page/signup_page.dart';
import 'package:kasir_cerdas/widget/signupin_switch.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  static const route = '/onboarding';

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset(onBoardingImage),
            const Spacer(flex: 3),
            const Text(
              'Selamat Datang Di Kasir Cerdas PM',
              textAlign: TextAlign.center,
              style: largeTitleStyle,
            ),
            const Spacer(),
            const Text(
              'Aplikasi Kasir Cerdas Hasil Proyek Mandiri Mahasiswa Polinela',
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            SignUpInSwitch(
              onSignUp: () {
                Navigator.pushNamed(context, SignupPage.route);
              },
              onSignIn: () {
                Navigator.pushNamed(context, SigninPage.route);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
