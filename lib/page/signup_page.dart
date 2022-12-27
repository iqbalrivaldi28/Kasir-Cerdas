import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/shop_register_page.dart';
import 'package:kasir_cerdas/page/signin_page.dart';
import 'package:kasir_cerdas/provider/auth.dart';
import 'package:kasir_cerdas/widget/cta_button.dart';
import 'package:kasir_cerdas/widget/password_field.dart';
import 'package:kasir_cerdas/widget/text_link.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  static const route = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  late final TextEditingController nameController;
  late final TextEditingController pwdController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    pwdController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    pwdController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
                        const Spacer(flex: 2),
                        const Text(
                          'Daftar Akun',
                          textAlign: TextAlign.center,
                          style: largeTitleStyle,
                        ),
                        const Spacer(flex: 2),
                        const Text(
                          'Silahkan mendaftarkan akun di aplikasi Kasir Cerdas Proyek Mandiri Mahasiswa Polinela',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        const Spacer(flex: 2),
                        TextFormField(
                          controller: nameController,
                          validator: ValidationBuilder().build(),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Nama Anda',
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          validator: ValidationBuilder().email().build(),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Email Anda',
                          ),
                          style: const TextStyle(fontSize: 12),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        PasswordField(controller: pwdController),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: phoneController,
                          validator: ValidationBuilder().phone().build(),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Nomor Telepon Anda',
                          ),
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Text(
                          'Terima Kasih sudah mau menjadi bagian dari kasir cerdas',
                          style: TextStyle(
                            height: 3,
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        CTAButton(
                          text: 'Daftar',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              auth.signup(
                                nameController.text,
                                pwdController.text,
                                phoneController.text,
                                emailController.text,
                              );
                              Navigator.pushNamed(context, ShopRegisterPage.route);
                            }
                          },
                        ),
                        const Spacer(),
                        const Text(
                          'Sudah punya akun?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 2,
                            fontSize: 12,
                          ),
                        ),
                        TextLink(
                          'Masuk disini',
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              SigninPage.route,
                              (route) => false,
                            );
                          },
                        ),
                        const Spacer(),
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
