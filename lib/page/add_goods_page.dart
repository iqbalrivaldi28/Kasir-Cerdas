import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/utility/appbar_height.dart';
import 'package:kasir_cerdas/utility/rupiah.dart';
import 'package:kasir_cerdas/widget/basic_textfield.dart';
import 'package:kasir_cerdas/widget/long_fab.dart';

class AddGoodsPage extends StatefulWidget {
  const AddGoodsPage({
    Key? key,
    required this.code,
  }) : super(key: key);

  final String code;

  static const route = '/addgoods';

  @override
  State<AddGoodsPage> createState() => _AddGoodsPageState();
}

class _AddGoodsPageState extends State<AddGoodsPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  pickImage({bool withCamera = false}) async {
    try {
      image = await _picker.pickImage(
        source: withCamera ? ImageSource.camera : ImageSource.gallery,
      );
      setState(() {});
    } catch (e) {
      print('gagal dah');
    }
  }

  late final TextEditingController nameController;
  late final TextEditingController stockController;
  late final TextEditingController codeController;
  late final TextEditingController sellPriceController;
  late final TextEditingController buyPriceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    stockController = TextEditingController();
    codeController = TextEditingController(text: widget.code);
    sellPriceController = TextEditingController();
    buyPriceController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    stockController.dispose();
    codeController.dispose();
    sellPriceController.dispose();
    buyPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: bodyWithAppbarHeight(context),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    image == null
                        ? const Icon(
                            Icons.photo,
                            size: 70,
                          )
                        : Image.file(
                            File(image!.path),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                    const Text(
                      'Tambah Foto',
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            pickImage(withCamera: true);
                          },
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: pickImage,
                          icon: const Icon(
                            Icons.folder_outlined,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    mvDivider,
                    BasicTextField(
                      validator: ValidationBuilder().build(),
                      controller: nameController,
                      hint: 'Nama Barang',
                    ),
                    BasicTextField(
                      validator: ValidationBuilder().build(),
                      keyboardType: TextInputType.number,
                      controller: stockController,
                      hint: 'Stok Barang',
                    ),
                    BasicTextField(
                      validator: ValidationBuilder().build(),
                      controller: codeController,
                      readOnly: true,
                    ),
                    BasicTextField(
                      validator: ValidationBuilder().build(),
                      keyboardType: TextInputType.number,
                      controller: buyPriceController,
                      hint: 'Harga Beli',
                    ),
                    BasicTextField(
                      validator: ValidationBuilder().build(),
                      controller: sellPriceController,
                      hint: 'Harga Jual',
                      keyboardType: TextInputType.number,
                    ),
                    const Spacer(),
                    LongFab(
                      child: const Text('Simpan'),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                              builder: (_) => const Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ));
                          FirestoreHelper.createProduct(
                            name: nameController.text,
                            sellPrice: sellPriceController.text,
                            buyPrice: buyPriceController.text,
                            code: codeController.text,
                            stock: stockController.text,
                            image: image?.path,
                            userId: userId,
                          ).then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) {
                                return const MainPage(initialPage: 1);
                              }),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RupiahFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int amount = int.parse(
      newValue.text.replaceAll(RegExp('[^0-9]'), ''),
    );
    return TextEditingValue(
      text: rupiah(amount),
      selection: newValue.selection,
    );
  }
}
