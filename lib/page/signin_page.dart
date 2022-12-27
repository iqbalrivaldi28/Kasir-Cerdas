import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:kasir_cerdas/constant/assets.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/signup_page.dart';
import 'package:kasir_cerdas/provider/auth.dart';
import 'package:kasir_cerdas/widget/cta_button.dart';
import 'package:kasir_cerdas/widget/password_field.dart';
import 'package:kasir_cerdas/widget/text_link.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  static const route = '/signin';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late final TextEditingController pwdController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    pwdController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    pwdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 3),
                        Image.asset(signInImage),
                        const Spacer(flex: 3),
                        const Text(
                          'Masuk',
                          textAlign: TextAlign.center,
                          style: largeTitleStyle,
                        ),
                        const Spacer(flex: 2),
                        TextFormField(
                          controller: emailController,
                          validator: ValidationBuilder().email().build(),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Email Anda',
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        PasswordField(controller: pwdController),
                        const Spacer(flex: 2),
                        CTAButton(
                            text: 'Masuk',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                auth.login(context, pwdController.text,
                                    emailController.text);
                              }
                            }),
                        const Spacer(flex: 2),
                        const Text(
                          'Belum punya akun?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 2,
                            fontSize: 12,
                          ),
                        ),
                        TextLink(
                          'Daftar disini',
                          onTap: () {
                            Navigator.pushNamed(context, SignupPage.route);
                          },
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
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
