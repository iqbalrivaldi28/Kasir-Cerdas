import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/constant/colors.dart';
import 'package:kasir_cerdas/constant/shapes.dart';
import 'package:kasir_cerdas/model/profile.dart';
import 'package:kasir_cerdas/services/session.dart';
import 'package:kasir_cerdas/widget/basic_textfield.dart';

import 'profile_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const route = '/editprofile';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addresController;

  Profile profile = Session.user;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addresController = TextEditingController();
    _getdataFromDatabase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirestoreHelper.getUserByEmail(Session.user.email!).then((userData) {
        Session.user = Profile.fromJson(userData);
        nameController.text = Session.user.name ?? '';
        emailController.text = Session.user.email ?? '';
        phoneController.text = Session.user.phone ?? '';
        addresController.text = Session.user.address ?? '';
      });
    });
  }

  Future _getdataFromDatabase<Profil>() async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          profile = profile.copyWith(
            name: snapshot.data()!["name"],
            email: snapshot.data()!["email"],
            image: snapshot.data()!["image"],
            phone: snapshot.data()!["phone"],
            address: snapshot.data()!["address"],
          );
        });
      } else {}
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addresController.dispose();
    super.dispose();
  }

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

  submit() async {
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
    String? imageUrl;

    final data = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addresController.text,
    };

    if (image != null) {
      imageUrl = await FirestoreHelper.uploadImage(File(image!.path));
      data['image'] = imageUrl;
    }

    Session.user = Session.user.copyWith(
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      image: data['image'],
    );

    final docUser = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    docUser.update(data).then((_) => Navigator.pushReplacementNamed(context, ProfilePage.route));
  }

  Widget getImage() {
    if (image != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.file(
            File(image!.path),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ));
    }
    if (profile.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: profile.image!,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    }

    return const CircleAvatar(
      radius: 50,
      child: Icon(Icons.person),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            getImage(),
            svDivider,
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
              hint: 'Nama',
              controller: nameController,
            ),
            BasicTextField(
              hint: 'Email',
              controller: emailController,
            ),
            BasicTextField(
              hint: 'telepon',
              controller: phoneController,
            ),
            BasicTextField(
              hint: 'Alamat',
              controller: addresController,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: submit,
        extendedPadding: EdgeInsets.zero,
        label: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Simpan'),
            ],
          ),
        ),
      ),
    );
  }
}
