import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/constant/typography.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/widget/cta_button.dart';

class ShopRegisterPage extends StatefulWidget {
  const ShopRegisterPage({Key? key}) : super(key: key);

  static const route = '/shopRegister';

  @override
  State<ShopRegisterPage> createState() => _ShopRegisterPageState();
}

class _ShopRegisterPageState extends State<ShopRegisterPage> {
  late final TextEditingController tokoController;
  late final TextEditingController addresController;

  @override
  void initState() {
    super.initState();
    tokoController = TextEditingController();
    addresController = TextEditingController();
  }

  @override
  void dispose() {
    tokoController.dispose();
    addresController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                mvDivider,
                const Text(
                  'Data Toko',
                  textAlign: TextAlign.center,
                  style: largeTitleStyle,
                ),
                mvDivider,
                const Text(
                  'Anda baru saja masuk di Aplikasi Kasir Cerdas, Silahkan untuk mengisi data toko Anda di bawah ini.',
                  textAlign: TextAlign.center,
                  style: subtitleFontStyle,
                ),
                lvDivider,
                TextFormField(
                  controller: tokoController,
                  validator: ValidationBuilder().build(),
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Nama Toko Anda',
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
                mvDivider,
                TextFormField(
                  controller: addresController,
                  validator: ValidationBuilder().build(),
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Alamat Toko Anda',
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
                lvDivider,
                CTAButton(
                  text: 'Simpan',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final docUser = FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid);
                      docUser.update({
                        'shop_name': tokoController.text,
                        'address': addresController.text,
                      });
                      print('berhasil');
                      Navigator.pushNamed(context, MainPage.route);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
