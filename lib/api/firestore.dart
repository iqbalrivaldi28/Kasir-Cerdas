import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kasir_cerdas/model/cart.dart';

import 'package:kasir_cerdas/model/goods.dart';
import 'package:kasir_cerdas/model/report.dart';
import 'package:kasir_cerdas/model/transaction.dart';

import 'package:kasir_cerdas/services/session.dart';

class FirestoreHelper {
  static final _firestore = FirebaseFirestore.instance;
  static Future createProduct({
    required String name,
    required String sellPrice,
    required String buyPrice,
    required String code,
    required String? image,
    required String stock,
    required String userId,
  }) async {
    if (image != null) {
      await uploadImage(File(image)).then((url) => image = url);
    }

    final docProduct = FirebaseFirestore.instance.collection('products').doc();

    final goods = Goods(
      userId: userId,
      name: name,
      sellPrice: int.parse(sellPrice),
      buyPrice: int.parse(buyPrice),
      code: code,
      stock: int.parse(stock),
      image: image,
      date: DateTime.now(),
      uuid: docProduct.id,
    );
    final json = goods.toJson();
    await docProduct.set(json);
  }

  static Future createTransaction({
    required String name,
    required String sellPrice,
    required String buyPrice,
    required String code,
    required String? image,
    required String stock,
    required int totalOrder,
  }) async {
    final docTransaction = FirebaseFirestore.instance.collection('transaction').doc();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final transaction = TransactionData(
      userId: userId,
      name: name,
      sellPrice: int.parse(sellPrice),
      buyPrice: int.parse(buyPrice),
      code: code,
      stock: int.parse(stock),
      image: image,
      date: DateTime.now(),
      uuid: docTransaction.id,
      totalOrder: totalOrder,
    );

    final json = transaction.toJson();

    await docTransaction.set(json);
  }

  static Future createCart({
    required String? name,
    required String? sellPrice,
    required String? buyPrice,
    required String? code,
    required String? image,
    required String? stock,
    required String? totalOrder,
    required String? profit,
    String? subTotal,
    String? cash,
  }) async {
    final docCart = FirebaseFirestore.instance.collection('report').doc();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final cart = Cart(
      cash: int.parse(cash!),
      subTotal: int.parse(subTotal!),
      profit: int.parse(profit!),
      userId: userId,
      name: name,
      sellPrice: int.parse(sellPrice!),
      buyPrice: int.parse(buyPrice!),
      code: code,
      stock: int.parse(stock!),
      image: image,
      date: DateTime.now(),
      uuid: docCart.id,
      totalOrder: int.parse(totalOrder!),
    );

    final json = cart.toJson();

    await docCart.set(json);
  }

  static Future createLaporan({
    required String? name,
    required String? totalOrder,
    required String? profit,
    required String? totalTransaction,
    required String? income,
  }) async {
    final docCart = FirebaseFirestore.instance.collection('laporan').doc();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final cart = Report(
      totalTransaction: int.parse(totalTransaction!),
      profit: int.parse(profit!),
      userId: userId,
      income: int.parse(income!),
      date: DateTime.now(),
      uuid: docCart.id,
    );

    final json = cart.toJson();

    await docCart.set(json);
  }

  static Future getTransactionList() async {
    List itemsList = [];
    try {
      await FirebaseFirestore.instance.collection("transaction").get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemsList.add(element);
        }
      });
      return itemsList;
    } catch (e) {}
  }

  static Future getLaporan() async {
    List itemsList = [];
    try {
      await FirebaseFirestore.instance.collection("laporan").get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemsList.add(element);
        }
      });
      return itemsList;
    } catch (e) {}
  }

  static Future<List<dynamic>?> getReport() async {
    List itemsList = [];
    try {
      await FirebaseFirestore.instance.collection("report").get().then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          itemsList.add(element);
        }
      });
      return itemsList;
    } catch (e) {
      return null;
    }
  }

  static Future<void> addProduct({
    required Map<String, dynamic> data,
  }) async {
    String? imagePath = data['image'];
    if (imagePath != null) {
      await uploadImage(File(imagePath)).then((url) {
        data['image'] = url;
      });
    }
    add(collectionName: 'products', data: data);
  }

  static Future<List<Map<String, dynamic>>> getProduct() async {
    List<Map<String, dynamic>> data = [];
    await get(collectionName: 'products').then((value) {
      data = value.docs.map((doc) {
        var dat = doc.data();
        dat['uuid'] = doc.get('uuid');
        return dat;
      }).toList();
    });

    return data;
  }

  static Future<List<Map<String, dynamic>>> getTransactionFirebase() async {
    List<Map<String, dynamic>> data = [];
    await get(collectionName: 'transaction').then((value) {
      data = value.docs.map((doc) {
        var dat = doc.data();
        return dat;
      }).toList();
    });

    return data;
  }

  static Future<void> add({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    _firestore.collection(collectionName).add(data).catchError(
      (e) {
        log(e);
      },
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collectionName,
  }) async {
    return await _firestore.collection(collectionName).where('user_id', isEqualTo: Session.user.id).get();
  }

  static Future<void> update({
    required String collection,
    required Map<String, dynamic> data,
    required String uuid,
  }) async {
    _firestore.collection(collection).doc(uuid).update(data).catchError(
      (e) {
        log(e);
      },
    );
  }

  static Future<void> delete({required String collectionName, required String documentID}) async {
    _firestore.collection(collectionName).doc(documentID).delete().catchError(
      (e) {
        log(e);
      },
    );
  }

  static Future<dynamic> getUserByEmail(String email) async {
    CollectionReference ref = _firestore.collection('users');

    QuerySnapshot querySnapshot = await ref.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }

  static Future<dynamic> getProductByID(String id) async {
    CollectionReference ref = _firestore.collection('products');

    QuerySnapshot querySnapshot = await ref.where('uuid', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }

  static Future<String> uploadImage(File image) async {
    String userId = Session.user.id ?? FirebaseAuth.instance.currentUser!.uid;
    Reference storageRef = FirebaseStorage.instance.ref();
    UploadTask task = storageRef.child("$userId/images/${DateTime.now()}").putFile(image);
    TaskSnapshot snapshot = await task.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
