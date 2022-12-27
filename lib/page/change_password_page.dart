import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/signin_page.dart';
import 'package:kasir_cerdas/widget/cta_button.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const route = '/changePassword';

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
                      Image.asset(changePasswordImage),
                      const Spacer(flex: 3),
                      const Text(
                        'Ubah Kata Sandi',
                        textAlign: TextAlign.center,
                        style: largeTitleStyle,
                      ),
                      const Spacer(flex: 1),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kata Sandi Baru Anda',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.visibility_off),
                          ),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Spacer(flex: 2),
                      CTAButton(
                        text: 'Konfirmasi',
                        onTap: () {
                          Navigator.pushNamed(context, SigninPage.route);
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
