import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/change_password_page.dart';
import 'package:kasir_cerdas/widget/cta_button.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  static const route = '/otp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 5),
                      Image.asset(otpImage),
                      const Spacer(flex: 3),
                      const Text(
                        'Masukkan Kode OTP',
                        textAlign: TextAlign.center,
                        style: largeTitleStyle,
                      ),
                      const Spacer(flex: 1),
                      const Text(
                        'Kode 4 digit telah dikirim ke (406) 555-0120',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const Spacer(flex: 2),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kode OTP Anda',
                        ),
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Spacer(flex: 2),
                      CTAButton(
                        text: 'Konfirmasi',
                        onTap: () {
                          Navigator.pushNamed(
                              context, ChangePasswordPage.route);
                        },
                      ),
                      const Spacer(flex: 5),
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
}
