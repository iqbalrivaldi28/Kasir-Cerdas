import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/api/firestore.dart';
import 'package:kasir_cerdas/page/main_page.dart';
import 'package:kasir_cerdas/services/session.dart';

class Auth with ChangeNotifier {
  final auth = FirebaseAuth.instance;

  Stream<User?> changeState() {
    return auth.authStateChanges();
  }

  void login(BuildContext context, String pwd, String email) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: pwd).then((value) {
        log("${value.user?.uid}");
        FirestoreHelper.getUserByEmail(email).then((userData) {
          Session.login(userData);
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainPage.route,
            (route) => false,
          );
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text(
                  'No user found for that email.',
                  style: TextStyle(fontSize: 12),
                ),
              );
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text(
                  'Wrong password provided for that user.',
                  style: TextStyle(fontSize: 12),
                ),
              );
            });
      }
    }
  }

  void signup(
    String? name,
    String pwd,
    String? phone,
    String email,
  ) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'phone': phone,
      };

      final result = await auth.createUserWithEmailAndPassword(email: email, password: pwd);
      FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set(data).then((_) => Session.login(data));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot<Object?>> getData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference product = firestore.collection("users");
    return product.get();
  }
}
